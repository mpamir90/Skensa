import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:meta/meta.dart';
import 'package:skensa/Services/FireStoreService.dart';

part 'masterconfiguration_event.dart';
part 'masterconfiguration_state.dart';

class MasterconfigurationBloc
    extends Bloc<MasterconfigurationEvent, MasterconfigurationState> {
  MasterconfigurationBloc() : super(MasterconfigurationInitial());

  @override
  Stream<MasterconfigurationState> mapEventToState(
    MasterconfigurationEvent event,
  ) async* {
    //
    if (event is GetGuruForKaprog) {
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        try {
          List<QueryDocumentSnapshot> result =
              await FirestoreService().getGuruKaprog();
          yield OnGetGuruForKaprogSucceded(result);
        } catch (e) {
          yield OnGetGuruForKaprogError(e.message);
        }
      } else {
        yield OnGetGuruForKaprogError("Jaringan Internet Tidak Ditemukan");
      }
    }
    //
    if (event is AddJurusan) {
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        await FirestoreService().addJurusan(event.namaJurusan, event.singkatan,
            event.namaLengkapGuru, event.uidGuru);
        yield OnAddJurusanSucceded();
      } else {
        yield OnAddJurusanError("Jaringan Tidak Ditemukan");
      }
    }
    //
    if (event is GetJurusanAll) {
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        try {
          QuerySnapshot result = await FirestoreService().getAllJurusan();
          yield OnGetJurusanSucceded(result);
        } catch (e) {
          yield OnGetJurusanError(e.message);
        }
      } else {
        yield OnGetJurusanError("Jaringan Tidak Ditemukan");
      }
    }
    //
    if (event is AddKelas) {
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        try {
          List<String> result = await FirestoreService().addKelas(
              event.jurusanSingkatan,
              event.jumlahTingkatan,
              event.jumlahKelasPerTingkatan,
              event.jurusan);
          yield OnAddKelasSucceded(result);
        } catch (e) {
          yield OnAddKelasError(e.message);
        }
      } else {
        print("OnAddKelasError in bloc");
        yield OnAddKelasError("Jaringan Tidak Ditemukan");
      }
    }
    //

    if (event is GetKelasForWaliKelas) {
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        try {
          Map<String, QuerySnapshot> mapQuerySnapshot = {};
          mapQuerySnapshot = {
            "Kelas": await FirestoreService().getKelasForSetWaliKelas(),
            "Guru": await FirestoreService().getGuruWaliKelas()
          };

          yield OnGetKelasForWaliKelasSucceded(mapQuerySnapshot);
        } catch (e) {
          yield OnGetKelasForWaliKelasError(e.message);
        }
      } else {
        yield OnGetKelasForWaliKelasError("Jaringan Tidak Ditemukan");
      }
    }
    if (event is SetWaliKelas) {
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        try {
          FirestoreService().setWaliKelas(event.idKelas, event.namaKelas,
              event.namaLengkapGuru, event.uidGuru);
          yield OnSetWaliKelasSucceded();
        } catch (e) {
          yield OnSetWaliKelasError(e.message);
        }
      } else {
        yield OnSetWaliKelasError("Jaringan Tidak Ditemukan");
      }
    }

    if (event is AddMataPelajaran) {
      ConnectivityResult connectivityResult =
          await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        try {
          await FirestoreService().addMataPelajaran(event.namaMataPelajaran);

          yield OnAddMataPelajaranSucceded();
        } catch (e) {
          yield OnAddMataPelajaranError(e.toString());
        }
      } else {
        yield OnAddMataPelajaranError("Jaringan Tidak Ditemukan");
      }
    }
  }
}
