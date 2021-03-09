import 'package:division/division.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skensa/Master/MasterLoginView.dart';

import 'package:skensa/Style/LoginViewStyle.dart';
import 'package:skensa/View/Guru/GuruSignInView.dart';

import 'package:skensa/bloc/authbloc_bloc.dart';
import 'package:string_validator/string_validator.dart' as validator;

class GuruSignUpView extends StatelessWidget {
  TextEditingController cNamaLengkap = TextEditingController();
  TextEditingController cNamaPengguna = TextEditingController();
  TextEditingController cEmail = TextEditingController();
  TextEditingController cPassword = TextEditingController();
  TextEditingController cNoHp = TextEditingController();
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  bool autoValidate = false;
  RegExp regExp = RegExp(r'[^\s\w]');
  AuthblocBloc _authblocBloc = AuthblocBloc();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthblocBloc>(
      create: (context) => _authblocBloc,
      child: Scaffold(
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
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MasterLoginView()));
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
                        ..padding(top: 20, horizontal: 10),
                      child: ListView(
                        children: [
                          Form(
                            key: keyForm,
                            child: Column(
                              children: [
                                Txt(
                                  "Sign Up Guru",
                                  style: LoginViewStyle.fontStyle.clone()
                                    ..textColor(Colors.lightBlue)
                                    ..textAlign.center(),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Tidak Boleh Kosong";
                                    }
                                    if (regExp.hasMatch(value)) {
                                      return "Tidak Boleh Menggunakan Symbol";
                                    }
                                    if (value.length <= 2) {
                                      return "Minimal 3 Karakter";
                                    }
                                    return null;
                                  },
                                  controller: cNamaLengkap,
                                  decoration: InputDecoration(
                                      labelText: "Nama Lengkap",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(13))),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Tidak Boleh Kosong";
                                    }
                                    if (regExp.hasMatch(value)) {
                                      return "Tidak Boleh Menggunakan Symbol";
                                    }
                                    if (value.length <= 2) {
                                      return "Minimal 3 Karakter";
                                    }
                                    return null;
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: cNamaPengguna,
                                  decoration: InputDecoration(
                                      labelText: "Nama Pengguna",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(13))),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Tidak Boleh Kosong";
                                    }
                                    if (!validator.isEmail(value)) {
                                      return "Format Email Yang Benar";
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
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Tidak Boleh Kosong";
                                    }
                                    if (regExp.hasMatch(value)) {
                                      return "Tidak Boleh Menggunakan Symbol";
                                    }
                                    if (value.length <= 5) {
                                      return "Minimal 6 Karakter";
                                    }
                                    return null;
                                  },
                                  controller: cPassword,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      labelText: "Password",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(13))),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Tidak Boleh Kosong";
                                    }
                                    if (!validator.isNumeric(value)) {
                                      return "Harus Berisi Angka";
                                    }
                                    if (value.length <= 10) {
                                      return "Minimal 11 Karakter";
                                    }
                                    return null;
                                  },
                                  controller: cNoHp,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                      labelText: "Nomor Handphone",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(13))),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                              ],
                            ),
                          ),
                          BlocListener<AuthblocBloc, AuthblocState>(
                              listener: (context, state) {
                                if (state is OnSignUpGuruLoading) {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text("Loading..."),
                                          ));
                                }
                                if (state is OnSignUpGuruSucceded) {
                                  Navigator.pop(context);
                                  debugPrint("OnSignUpGuruSucceded : ");
                                  showDialog(
                                    barrierDismissible: false,
                                    builder: (context) => AlertDialog(
                                      title:
                                          Text("Pendaftaran Berhasil Dibuat"),
                                      content: Text(
                                          "Silahkan Verifikasi Email Anda Untuk Bisa Login"),
                                      actions: [
                                        FlatButton(
                                          child: Text("Ok"),
                                          color: Colors.lightBlue,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    ),
                                    context: context,
                                  ).then((value) {
                                    Navigator.pop(context);
                                  });
                                }

                                if (state is OnSignUpGuruError) {
                                  Navigator.pop(context);
                                  showDialog(
                                    builder: (context) => AlertDialog(
                                      title: Text("Pendaftaran Gagal"),
                                      content: Text(state.message),
                                      actions: [
                                        Center(
                                          child: FlatButton(
                                            child: Text("Back"),
                                            color: Colors.lightBlue,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    context: context,
                                  );
                                }
                              },
                              child: CupertinoButton(
                                child: Txt("Sign Up"),
                                color: Colors.lightBlue,
                                onPressed: () {
                                  keyForm.currentState.save();
                                  debugPrint("Form Validate : " +
                                      keyForm.currentState
                                          .validate()
                                          .toString());
                                  if (keyForm.currentState.validate()) {
                                    _authblocBloc.add(SignUpGuru(
                                        cNamaLengkap.text,
                                        cNamaPengguna.text,
                                        cEmail.text,
                                        cPassword.text,
                                        cNoHp.text,
                                        context));
                                  }
                                },
                              )),
                          SizedBox(
                            height: 40,
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
