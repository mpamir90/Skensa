import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:meta/meta.dart';
import 'package:skensa/Services/FireStoreService.dart';

part 'buatkuis_event.dart';
part 'buatkuis_state.dart';

class BuatkuisBloc extends Bloc<BuatkuisEvent, BuatkuisState> {
  BuatkuisBloc() : super(BuatkuisInitial());

  @override
  Stream<BuatkuisState> mapEventToState(
    BuatkuisEvent event,
  ) async* {
    if (event is ChoisedJawaban) {
      yield OnChoisedJawabanComplete();
    }
    if (event is CreateKuis) {
      yield OnCreateKuisLoading();
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        try {
          await FirestoreService().createKuis(
              event.namaTugas,
              event.namaMataPelajaran,
              event.guru,
              event.kelas,
              event.soal,
              event.waktuKuis);
          yield OnCreateKuisSucceded();
        } catch (e) {
          yield OnCreateKuisError(e.toString());
        }
      } else {
        yield OnCreateKuisError("Jaringan Tidak Ditemukan");
      }
    }
  }
}
