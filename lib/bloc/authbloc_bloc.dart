import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:skensa/Services/AuthService.dart';
import 'package:skensa/Services/FireStoreService.dart';

part 'authbloc_event.dart';
part 'authbloc_state.dart';

class AuthblocBloc extends Bloc<AuthblocEvent, AuthblocState> {
  AuthblocBloc() : super(AuthblocInitial());

  @override
  Stream<AuthblocState> mapEventToState(
    AuthblocEvent event,
  ) async* {
    ConnectivityResult connectivityResult;
    if (event is SignIn) {
      yield OnSignInLoading();
      connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        try {
          Map<String, dynamic> result = await AuthService()
              .signInWithAccountSkensa(event.email, event.password);
          yield OnSignInSucceded(result);
        } catch (e) {
          yield OnSignInError(e.message);
        }
      } else {
        yield OnSignInError("jaringan Tidak Ditemukan");
      }
    }

    if (event is SignUpGuru) {
      yield OnSignUpGuruLoading();
      connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        try {
          User user = await AuthService().signUpGuruWithAccountSkensa(
              event.namaLengkap,
              event.namaPengguna,
              event.email,
              event.password,
              event.noHp);
          yield OnSignUpGuruSucceded(user);
        } catch (e) {
          print(e.message);
          yield OnSignUpGuruError(e.message);
        }
      } else {
        yield OnSignUpGuruError("Jaringan Tidak Ditemukan");
      }
    }
    if (event is SignInGuru) {
      yield OnSignInGuruLoading();
      connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        try {
          Map<String, dynamic> result = await AuthService()
              .signInGuruWithAccountSkensa(event.email, event.password);
          yield OnSignInGuruSucceded(result);
        } catch (e) {
          yield OnSignInGuruError(e.toString());
        }
      } else {
        yield OnSignInGuruError("Jaringan Internet Tidak Ditemukan");
      }
    }

    if (event is GetConfigPendaftaran) {
      print("GetConfigPendaftaran");
      yield OnGetConfigPendaftaranLoading();
      connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        try {
          DocumentSnapshot result =
              await FirestoreService().getConfigPendaftaran();

          yield OnGetConfigPendaftaranSucceded(result);
        } catch (e) {
          OnGetConfigPendaftaranError(e.message);
        }
      } else {
        yield OnGetConfigPendaftaranError("Jaringan Tidak Ditemukan");
      }
    }
    if (event is GetConfigPendaftaranSiswa) {
      yield OnGetConfigPendaftaranSiswaLoading();
      print("GetConfigPendaftaranSiswa");
      connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        try {
          DocumentSnapshot resultPermission =
              await FirestoreService().getConfigPendaftaran();
          QuerySnapshot jurusan = await FirestoreService().getAllJurusan();
          print("Lenght Jurusan : " + jurusan.docs.length.toString());
          QuerySnapshot kelas = await FirestoreService().getAllKelas();
          print("Length Kelas : " + kelas.docs.length.toString());
          Map<String, QuerySnapshot> jurusanAndKelas = {
            "Jurusan": jurusan,
            "Kelas": kelas
          };

          yield OnGetConfigPendaftaranSiswaSucceded(
              resultPermission, jurusanAndKelas);
        } catch (e) {
          yield OnGetConfigPendaftaranSiswaError(e.toString());
        }
      } else {
        yield OnGetConfigPendaftaranSiswaError("Jaringan Tidak Ditemukan");
      }
    }

    if (event is AddSiswa) {
      yield OnAddSiswaLoading();
      connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        try {
          User user = await AuthService().signUpWithAccountSkensa(
              event.namaLengkap,
              event.namaPengguna,
              event.email,
              event.password,
              event.jurusan,
              event.kelas,
              event.absen,
              event.noHp);
          yield OnAddSiswaSucceded(user);
        } catch (e) {
          yield OnAddSiswaError(e.message);
        }
      } else {
        yield OnAddSiswaError("Jaringan Tidak Ditemukan");
      }
    }
  }
}
