import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:meta/meta.dart';
import 'package:skensa/Services/FireStoreService.dart';

part 'gurumanagement_event.dart';
part 'gurumanagement_state.dart';

class GurumanagementBloc
    extends Bloc<GurumanagementEvent, GurumanagementState> {
  GurumanagementBloc() : super(GurumanagementInitial());

  @override
  Stream<GurumanagementState> mapEventToState(
    GurumanagementEvent event,
  ) async* {
    ConnectivityResult connectivityResult;
    if (event is GetInfoKelas) {
      yield OnGetInfoKelasLoading();
      connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        try {
          DocumentSnapshot result =
              await FirestoreService().getInfoKelas(event.idKelas);
          QuerySnapshot allPelajaran =
              await FirestoreService().getAllPelajaran();
          QuerySnapshot allGuru = await FirestoreService().getAllGuru();
          yield OnGetInfoKelasSucceded(result, allPelajaran, allGuru);
        } catch (e) {
          yield OnGetInfoKelasError(e.toString());
        }
      } else {
        yield OnGetInfoKelasError("Jaringan Tidak Ditemukan");
      }
    }
    if (event is AddMataPelajaranKelas) {
      yield OnAddMataPelajaranKelasLoading();
      connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        try {
          await FirestoreService().addMataPelajaranKelas(
              event.namaKelas, event.idKelas, event.listMataPelajaran);
          yield OnAddMataPelajaranKelasSucceded();
        } catch (e) {
          yield OnAddMataPelajaranKelasError(e.toString());
        }
      } else {
        yield OnAddMataPelajaranKelasError("Jaringan Tidak Ditemukan");
      }
    }

    if (event is GetPropertyMengajarGuru) {
      yield OnGetPropertyMengajarGuruLoading();
      connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        try {
          QuerySnapshot allKelas = await FirestoreService().getAllKelas();
          QuerySnapshot allMataPelajaran =
              await FirestoreService().getAllPelajaran();
          yield OnGetPropertyMengajarGuruSucceded(allKelas, allMataPelajaran);
        } catch (e) {
          yield OnGetPropertyMengajarGuruError(e.toString());
        }
      } else {
        yield OnGetPropertyMengajarGuruError("Jaringan Tidak Ditemukan");
      }
    }
    if (event is AddInitialState) {
      yield GurumanagementInitial();
    }

    if (event is AddMataPelajaranGuru) {
      yield OnAddMataPelajaranGuruLoading();
      connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        try {
          FirestoreService().addMataPelajaranGuru(event.idGuru, event.namaGuru,
              event.mataPelajaran, event.listKelas);
          yield OnAddMataPelajaranGuruSucceded();
        } catch (e) {
          yield OnAddMataPelajaranGuruError(e.toString());
        }
      } else {
        yield OnAddMataPelajaranGuruError("Jaringan Tidak Ditemukan");
      }
    }
  }
}
