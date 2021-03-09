import 'package:division/division.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skensa/Style/LoginViewStyle.dart';
import 'package:skensa/View/Guru/GuruSignInView.dart';

import 'package:skensa/View/HomeView.dart';
import 'package:skensa/View/SignUpView.dart';
import 'package:skensa/bloc/authbloc_bloc.dart';
import 'package:skensa/bloc/hydrateduser_bloc.dart';
import 'package:string_validator/string_validator.dart';

class LoginView extends StatelessWidget {
  TextEditingController cEmail = TextEditingController();
  TextEditingController cPassword = TextEditingController();
  GlobalKey<FormState> keyForm = GlobalKey();
  HydrateduserBloc userBloc;
  LoginView(this.userBloc);
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthblocBloc>(
      create: (context) => AuthblocBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              color: Colors.lightBlue,
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: double.maxFinite,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onLongPress: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            GuruSignInView(userBloc)));
                              },
                              child: Image(
                                image: AssetImage("assets/skensa.png"),
                                width: 40,
                              ),
                            ),
                            Txt(
                              "  SKENSA",
                              style: LoginViewStyle.fontStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: Parent(
                      style: LoginViewStyle.loginContainer.clone()
                        ..width(double.maxFinite)
                        ..borderRadius(topLeft: 40, topRight: 40)
                        ..padding(top: 40, horizontal: 20),
                      child: ListView(
                        children: [
                          Center(
                            child: Txt(
                              "LOGIN",
                              style: LoginViewStyle.fontStyle.clone()
                                ..textColor(Colors.lightBlue),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Form(
                            key: keyForm,
                            child: Column(
                              children: [
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value.length == 0) {
                                      return "Tidak Boleh Kosong";
                                    }
                                    if (!isEmail(value)) {
                                      return "Masukan Format Email Yang Benar";
                                    }
                                    return null;
                                  },
                                  controller: cEmail,
                                  decoration: InputDecoration(
                                      labelText: "Email",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(13))),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  obscureText: true,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value.length == 0) {
                                      return "Tidak Boleh Kosong";
                                    }
                                    if (value.length <= 5) {
                                      return "Minimal 6 Digit";
                                    }
                                    return null;
                                  },
                                  controller: cPassword,
                                  decoration: InputDecoration(
                                      labelText: "Password",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(13))),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          BlocConsumer<AuthblocBloc, AuthblocState>(
                            listener: (context, state) {
                              if (state is OnSignInSucceded) {
                                if (!(state.result["Email Verified"] as bool)) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text(
                                                "Email Belum Diverifikasi"),
                                            content: Text(
                                                "Mohon Verifikasi Email Anda Terlebih Dahulu"),
                                          ));
                                } else {
                                  userBloc.add(AddInfoSiswa(
                                      state.result["DocumentSnapshotSiswa"]));
                                }
                              }
                              if (state is OnSignInError) {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text("Error Terdeteksi"),
                                          content: Text(state.errorMessage),
                                        ));
                              }
                            },
                            builder: (context, state) => CupertinoButton(
                              padding: EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  (state is OnSignInLoading)
                                      ? CircularProgressIndicator()
                                      : Image(
                                          image:
                                              AssetImage("assets/skensa.png"),
                                          width: 30,
                                        ),
                                  Txt(
                                    "   Login With Account SKENSA",
                                    style: TxtStyle()
                                      ..bold()
                                      ..fontSize(18)
                                      ..textColor(Colors.white)
                                      ..textOverflow(TextOverflow.ellipsis),
                                  ),
                                ],
                              ),
                              color: Colors.cyan,
                              onPressed: () {
                                keyForm.currentState.save();
                                if (keyForm.currentState.validate()) {
                                  if (state is! OnSignInLoading) {
                                    BlocProvider.of<AuthblocBloc>(context).add(
                                        SignIn(cEmail.text, cPassword.text));
                                  }
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 70,
                          ),
                          BlocConsumer<AuthblocBloc, AuthblocState>(
                            listener: (context, state) {
                              debugPrint("stated");
                              if (state is OnGetConfigPendaftaranSiswaError) {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text("Error Terdeteksi"),
                                          content: Text(state.errorMessage),
                                        ));
                              }
                              if (state
                                  is OnGetConfigPendaftaranSiswaSucceded) {
                                debugPrint(
                                    "OnGetConfigPendaftaranSiswaSucceded");
                                if (state.resultPermission
                                    .get("Siswa")["Status"]) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUpView(
                                              state.jurusanAndKelas["Jurusan"],
                                              state.jurusanAndKelas["Kelas"])));
                                } else {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text(
                                                "Izin Pendaftaran Ditolak"),
                                            content: Text(
                                                "Silahkan Minta Admin Untuk Membuka Pendaftaran"),
                                            actions: [
                                              CupertinoButton(
                                                color: Colors.lightBlue,
                                                child: Text("Kembali"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                          ));
                                }
                              }
                            },
                            builder: (context, state) => CupertinoButton(
                              color: Colors.lightGreen,
                              child:
                                  (state is OnGetConfigPendaftaranSiswaLoading)
                                      ? CircularProgressIndicator()
                                      : Txt("Not Have Account? Sign Up"),
                              onPressed: () {
                                if (state
                                    is! OnGetConfigPendaftaranSiswaLoading) {
                                  BlocProvider.of<AuthblocBloc>(context)
                                      .add(GetConfigPendaftaranSiswa());
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
