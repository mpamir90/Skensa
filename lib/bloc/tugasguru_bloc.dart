import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:meta/meta.dart';
import 'package:skensa/Services/FireStoreService.dart';

part 'tugasguru_event.dart';
part 'tugasguru_state.dart';

class TugasguruBloc extends Bloc<TugasguruEvent, TugasguruState> {
  TugasguruBloc() : super(TugasguruInitial());

  @override
  Stream<TugasguruState> mapEventToState(
    TugasguruEvent event,
  ) async* {
    if (event is GetTugas) {
      yield OnGetTugasLoading();
      ConnectivityResult connectivityResult;
      connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        try {
          List<Map<String, dynamic>> result = await FirestoreService().getTugas(
              event.namaMataPelajaran, event.idGuru, event.namaLengkapGuru);
          yield OnGetTugasSucceded(result);
        } catch (e) {
          yield OnGetTugasError(e.toString());
        }
      } else {
        yield OnGetTugasError("Jaringan Tidak Ditemukan");
      }
    }
  }
}
