import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:division/division.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skensa/Style/LoginViewStyle.dart';
import 'package:skensa/bloc/authbloc_bloc.dart';
import 'package:smart_select/smart_select.dart';
import 'package:string_validator/string_validator.dart';

class SignUpView extends StatelessWidget {
  TextEditingController cNamaLengkap = TextEditingController();
  TextEditingController cNamaPengguna = TextEditingController();
  TextEditingController cEmail = TextEditingController();
  TextEditingController cPassword = TextEditingController();
  TextEditingController cNoHp = TextEditingController();
  TextEditingController cAbsen = TextEditingController();
  List<S2Choice<QueryDocumentSnapshot>> choiceItemsJurusan = [];
  List<S2Choice<QueryDocumentSnapshot>> choiceItemsKelas = [];
  QueryDocumentSnapshot selectedItemJurusan;
  QueryDocumentSnapshot selectedItemKelas;
  QuerySnapshot jurusan;
  QuerySnapshot kelas;
  RegExp regExp = RegExp(r'[^\s\w]');
  GlobalKey<FormState> keyForm = GlobalKey();
  AuthblocBloc _authblocBloc = AuthblocBloc();
  SignUpView(this.jurusan, this.kelas);
  @override
  Widget build(BuildContext context) {
    choiceItemsJurusan = jurusan.docs
        .map<S2Choice<QueryDocumentSnapshot>>((e) =>
            S2Choice<QueryDocumentSnapshot>(
                title: e.get("Nama Jurusan"),
                value: e,
                subtitle: "Kepala Program : " +
                    e.get("Kepala Program")["Nama Lengkap"]))
        .toList();

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
                        ..padding(top: 20, horizontal: 10),
                      child: ListView(
                        children: [
                          Txt(
                            "Sign Up",
                            style: LoginViewStyle.fontStyle.clone()
                              ..textColor(Colors.lightBlue)
                              ..textAlign.center(),
                          ),
                          SizedBox(
                            height: 30,
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
                                    if (regExp.hasMatch(value)) {
                                      return "Tidak Boleh Menggunakan Symbol";
                                    }
                                    if (value.length <= 2) {
                                      return "Minimal 3 Digit";
                                    }
                                    if (value.length >= 15) {
                                      return "Maksimal 15 Digit";
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
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value.length == 0) {
                                      return "Tidak Boleh Kosong";
                                    }
                                    if (regExp.hasMatch(value)) {
                                      return "Tidak Boleh Menggunakan Symbol";
                                    }
                                    if (value.length <= 2) {
                                      return "Minimal 3 Digit";
                                    }
                                    if (value.length >= 15) {
                                      return "Maksimal 15 Digit";
                                    }
                                    return null;
                                  },
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
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value.length <= 5) {
                                      return "Minimal 6 Digit";
                                    }
                                    if (value.length == 0) {
                                      return "Tidak Boleh Kosong";
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
                                StatefulBuilder(builder: (context, myState) {
                                  return Column(
                                    children: [
                                      Card(
                                        child: SmartSelect.single(
                                            modalFilterHint: "Cari Jurusan",
                                            modalFilterAuto: true,
                                            modalFilter: true,
                                            title: "Pilih Jurusan",
                                            choiceItems: choiceItemsJurusan,
                                            value: selectedItemJurusan,
                                            onChange: (value) {
                                              selectedItemJurusan = value.value;
                                              choiceItemsKelas = [];
                                              kelas.docs.forEach((element) {
                                                if (element.get("Jurusan") ==
                                                    selectedItemJurusan
                                                        .get("Nama Jurusan")) {
                                                  choiceItemsKelas.add(S2Choice<QueryDocumentSnapshot>(
                                                      disabled: (element.get(
                                                                  "Wali Kelas") ==
                                                              null)
                                                          ? true
                                                          : false,
                                                      value: element,
                                                      title: element
                                                          .get("Nama Kelas"),
                                                      subtitle: (element.get(
                                                                  "Wali Kelas") ==
                                                              null)
                                                          ? "Belum Ada Wali Kelas"
                                                          : "Wali Kelas : " +
                                                              element.get(
                                                                      "Wali Kelas")[
                                                                  "Nama Lengkap"]));
                                                }
                                              });
                                              myState(() {});
                                            }),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Card(
                                        child: SmartSelect.single(
                                            modalFilterHint: "Cari Kelas",
                                            modalFilterAuto: true,
                                            modalFilter: true,
                                            title: "Pilih Kelas",
                                            choiceItems:
                                                (selectedItemJurusan != null)
                                                    ? choiceItemsKelas
                                                    : [],
                                            value: selectedItemKelas,
                                            onChange: (value) {
                                              selectedItemKelas = value.value;
                                            }),
                                      ),
                                    ],
                                  );
                                }),
                                SizedBox(
                                  height: 30,
                                ),
                                TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value.length == 0) {
                                      return "Tidak Boleh Kosong";
                                    }
                                    if (value.length >= 3) {
                                      return "Minimal 2 Digit";
                                    }
                                    if (!isNumeric(value)) {
                                      return "Harus Berupa Numeric";
                                    }
                                    return null;
                                  },
                                  controller: cAbsen,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                      labelText: "Absen",
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
                                    if (value.length == 0) {
                                      return "Tidak Boleh Kosong";
                                    }
                                    if (value.length <= 9) {
                                      return "Minimal 10 Digit";
                                    }
                                    if (!isNumeric(value)) {
                                      return "Harus Berupa Numeric";
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
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          BlocListener<AuthblocBloc, AuthblocState>(
                            listener: (context, state) {
                              if (state is OnAddSiswaLoading) {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => Dialog(
                                          child: Text("Loading..."),
                                        ));
                              }
                              if (state is OnAddSiswaSucceded) {
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text("Pendaftaran Succeded"),
                                          content: Text(
                                              "Silahkan Konfirmasi Email Anda Terlebih Dahulu"),
                                        )).then((value) {
                                  Navigator.pop(context);
                                });
                              }
                              if (state is OnAddSiswaError) {
                                Navigator.pop(context);
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text("Error Terdeteksi"),
                                          content: Text(state.errorMessage),
                                        ));
                              }
                            },
                            child: CupertinoButton(
                              child: Txt("Sign Up"),
                              color: Colors.lightBlue,
                              onPressed: () {
                                keyForm.currentState.save();
                                if (keyForm.currentState.validate()) {
                                  print("Tervalidasi");
                                  if (selectedItemKelas == null) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                            child: Text(
                                                "Kelas Tidak Boleh Kosong")));
                                  } else {
                                    print("bloc runned");
                                    _authblocBloc.add(AddSiswa(
                                        cNamaLengkap.text,
                                        cNamaPengguna.text,
                                        cEmail.text,
                                        cPassword.text,
                                        selectedItemJurusan.data(),
                                        selectedItemKelas.data(),
                                        cAbsen.text,
                                        cNoHp.text));
                                  }
                                }
                              },
                            ),
                          ),
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
