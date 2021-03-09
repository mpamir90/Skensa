import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:skensa/Services/AuthService.dart';
import 'package:skensa/Services/FireStoreService.dart';

part 'hydrateduser_event.dart';
part 'hydrateduser_state.dart';

class HydrateduserBloc
    extends HydratedBloc<HydrateduserEvent, HydrateduserState> {
  HydrateduserBloc() : super(HydrateduserInitial());

  @override
  Stream<HydrateduserState> mapEventToState(
    HydrateduserEvent event,
  ) async* {
    if (event is AddInfoGuru) {
      Map<String, dynamic> guru = event.guru.data();
      guru.addAll({"Path": event.guru.reference.path});
      print(guru.toString());
      yield OnAddInfoGuruSucceded(guru);
    }
    if (event is AddInfoSiswa) {
      Map<String, dynamic> result = {
        "Data": event.siswa.data(),
        "Path": event.siswa.reference.path
      };
      print(event.siswa.data().toString());

      yield OnAddInfoSiswaSucceded(result);
    }
    if (event is SignOut) {
      yield HydrateduserInitial();
    }
    if (event is UpdateDataGuru) {
      yield OnUpdateDataGuruLoading();
      try {
        Map<String, dynamic> data = await AuthService()
            .signInGuruWithAccountSkensa(event.email, event.password);
        DocumentSnapshot guruDocumentSnapshot =
            data["documentSnapshotGuru"] as DocumentSnapshot;
        Map<String, dynamic> guru = guruDocumentSnapshot.data();
        guru.addAll({"Path": guruDocumentSnapshot.reference.path});
        print(guru.toString());
        yield OnAddInfoGuruSucceded(guru);
      } catch (e) {
        yield OnUpdateDataGuruError(e.toString());
      }
    }
  }

  @override
  HydrateduserState fromJson(Map<String, dynamic> json) {
    print("FromJson : " + json.toString());
    if (json != null) {
      if (json["User"] != null) {
        if ((json["User"]["Path"] as String).split("/").first == "Guru") {
          return OnAddInfoGuruSucceded(json["User"]);
        }
        if ((json["User"]["Path"] as String).split("/").first == "Siswa") {
          return OnAddInfoSiswaSucceded(json["User"] as Map<String, dynamic>);
        } else {
          return HydrateduserInitial();
        }
      } else {
        return HydrateduserInitial();
      }
    } else {
      return HydrateduserInitial();
    }
  }

  @override
  Map<String, dynamic> toJson(HydrateduserState state) {
    if (state is OnAddInfoGuruSucceded) {
      return {"User": state.guru};
    }
    if (state is OnAddInfoSiswaSucceded) {
      return {"User": state.siswa};
    }
    return {"User": null};
  }
}
