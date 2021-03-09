import 'package:division/division.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:skensa/Style/LoginViewStyle.dart';
import 'package:skensa/View/Guru/GuruSignUpView.dart';
import 'package:skensa/View/Guru/HomeViewGuru.dart';
import 'package:skensa/bloc/authbloc_bloc.dart';
import 'package:skensa/bloc/hydrateduser_bloc.dart';
import 'package:string_validator/string_validator.dart' as validator;

class GuruSignInView extends StatelessWidget {
  TextEditingController cEmail = TextEditingController();
  TextEditingController cPassword = TextEditingController();
  GlobalKey<FormState> keyForm = GlobalKey();
  RegExp regExp = RegExp(r'[^\s\w]');
  AuthblocBloc _authblocBloc = AuthblocBloc();
  HydrateduserBloc userBloc;
  GuruSignInView(this.userBloc);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthblocBloc>(
          create: (context) => _authblocBloc,
        ),
      ],
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
                            Image(
                              image: AssetImage("assets/skensa.png"),
                              width: 40,
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
                      child: Column(
                        children: [
                          Txt(
                            "LOGIN Guru",
                            style: LoginViewStyle.fontStyle.clone()
                              ..textColor(Colors.lightBlue),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Form(
                            key: keyForm,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: cEmail,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Tidak Boleh Kosong";
                                    }
                                    if (!validator.isEmail(value)) {
                                      return "Masukan Format Email Yang Benar";
                                    }
                                    return null;
                                  },
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
                                  controller: cPassword,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (regExp.hasMatch(value)) {
                                      return "Password Tidak Boleh Menggunakan Symbol";
                                    }
                                    if (value.isEmpty) {
                                      return "Password Tidak Boleh Kosong";
                                    }
                                    if (value.length < 6) {
                                      return "Minimal 6 Karakter";
                                    }
                                    return null;
                                  },
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
                                if (state is OnSignInGuruSucceded) {
                                  debugPrint("OnSignInGuruSucceded : " +
                                      (state.result["Email Verified"] as bool)
                                          .toString());
                                  if (state.result["Email Verified"] == false) {
                                    showDialog(
                                      builder: (context) => AlertDialog(
                                        title:
                                            Text("Email Belum Terverifikasi"),
                                        content: Text(
                                            "Verfifikasi Email Anda Terlebih Dahulu"),
                                        actions: [
                                          FlatButton(
                                            child: Text("Back"),
                                            color: Colors.lightBlue,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      ),
                                      context: context,
                                    );
                                  } else {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => HomeViewGuru(
                                    //             state.result[
                                    //                 "documentSnapshotGuru"])));

                                    userBloc.add(AddInfoGuru(
                                        state.result["documentSnapshotGuru"]));
                                    Navigator.pop(context);
                                  }
                                }

                                if (state is OnSignInGuruError) {
                                  debugPrint(
                                      "OnSignInGuruError : " + state.message);
                                  keyForm.currentState.reset();
                                  showDialog(
                                    builder: (context) => AlertDialog(
                                      title: Text("Login Gagal"),
                                      content: Text(state.message),
                                      actions: [
                                        FlatButton(
                                          child: Text("Back"),
                                          color: Colors.lightBlue,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    ),
                                    context: context,
                                  );
                                }
                              },
                              builder: (context, state) => CupertinoButton(
                                  padding: EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      (state is OnSignInGuruLoading)
                                          ? CircularProgressIndicator(
                                              backgroundColor: Colors.white,
                                            )
                                          : Image(
                                              image: AssetImage(
                                                  "assets/skensa.png"),
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
                                    if (state is! OnSignInGuruLoading) {
                                      if (keyForm.currentState.validate()) {
                                        debugPrint("Email : " +
                                            cEmail.text +
                                            " Password : " +
                                            cPassword.text);

                                        _authblocBloc.add(SignInGuru(
                                            cEmail.text,
                                            cPassword.text,
                                            context));
                                      }
                                    }
                                  })),
                          SizedBox(
                            height: 70,
                          ),
                          BlocConsumer<AuthblocBloc, AuthblocState>(
                            listener: (context, state) {
                              if (state is OnGetConfigPendaftaranError) {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                        title: Text(state.errorMessage)));
                              }
                              if (state is OnGetConfigPendaftaranSucceded) {
                                debugPrint(state.result.get("Guru").toString());
                                if (state.result.get("Guru")["Status"]) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              GuruSignUpView()));
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
                              child: (state is OnGetConfigPendaftaranLoading)
                                  ? CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    )
                                  : Txt("Not Have Account? Sign Up"),
                              onPressed: () {
                                BlocProvider.of<AuthblocBloc>(context)
                                    .add(GetConfigPendaftaran());
                              },
                            ),
                          )
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
