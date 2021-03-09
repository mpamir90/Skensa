import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:division/division.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skensa/bloc/masterconfiguration_bloc.dart';
import 'package:smart_select/smart_select.dart';

class ConfigurationView extends StatelessWidget {
  TextEditingController cNamaJurusan = TextEditingController();
  TextEditingController cSingkatan = TextEditingController();
  String dKetuJurusan = "";
  MasterconfigurationBloc bloc = MasterconfigurationBloc();
  List<S2Choice<QueryDocumentSnapshot>> pilihKepalaProgramChoice = [];
  QueryDocumentSnapshot selectedGuruValue;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MasterconfigurationBloc>(
      create: (context) => bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text("SKENSA APP MANAGEMENT"),
        ),
        body: SafeArea(
          child: Container(
              child: ListView(
            children: [
              Container(
                color: Colors.blueAccent[100],
                child: Center(
                    child: Text(
                  "Jurusan",
                  style: TextStyle(fontSize: 20),
                )),
              ),
              GestureDetector(
                  child: BlocListener<MasterconfigurationBloc,
                      MasterconfigurationState>(
                    listener: (context, state) {
                      if (state is OnGetGuruForKaprogError) {
                        showDialog(
                            builder: (context) => AlertDialog(
                                  title: Text("Error Terdeteksi"),
                                  content: Text(state.message),
                                ),
                            context: context);
                      }
                      if (state is OnAddJurusanSucceded) {
                        Navigator.pop(context);
                        showDialog(
                            builder: (context) => AlertDialog(
                                  title: Text("Berhasil"),
                                  content: Text("Jurusan Baru Berhasil Dibuat"),
                                ),
                            context: context);
                      }
                      if (state is OnAddJurusanError) {
                        showDialog(
                            builder: (context) => AlertDialog(
                                  title: Text("Error Terdeteksi"),
                                  content: Text(state.errorMessage),
                                ),
                            context: context);
                      }
                      if (state is OnGetGuruForKaprogSucceded) {
                        debugPrint("OnGetGuruForKaprogSucceded");
                        pilihKepalaProgramChoice = state.result
                            .map<S2Choice<QueryDocumentSnapshot>>((e) =>
                                S2Choice<QueryDocumentSnapshot>(
                                    title: e.get("Nama Lengkap"), value: e))
                            .toList();
                        GlobalKey<FormState> keyForm = GlobalKey();
                        showDialog(
                                builder: (context) => Dialog(
                                      child: Parent(
                                        child: Container(
                                            child: ListView(
                                          shrinkWrap: true,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Txt(
                                                  "Buat Jurusan",
                                                  style: TxtStyle()
                                                    ..fontSize(20)
                                                    ..padding(bottom: 10),
                                                ),
                                                Container(
                                                  color: Colors.grey,
                                                  height: 3,
                                                ),
                                                Form(
                                                  key: keyForm,
                                                  child: Column(
                                                    children: [
                                                      Parent(
                                                        style: ParentStyle()
                                                          ..padding(all: 10),
                                                        child: TextFormField(
                                                          autovalidateMode:
                                                              AutovalidateMode
                                                                  .onUserInteraction,
                                                          validator: (value) {
                                                            if (value.length ==
                                                                0) {
                                                              return "Tidak Boleh Kosong";
                                                            }
                                                            return null;
                                                          },
                                                          controller:
                                                              cNamaJurusan,
                                                          decoration: InputDecoration(
                                                              labelText:
                                                                  "Nama Jurusan",
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              13))),
                                                        ),
                                                      ),
                                                      Parent(
                                                        style: ParentStyle()
                                                          ..padding(all: 10),
                                                        child: TextFormField(
                                                          autovalidateMode:
                                                              AutovalidateMode
                                                                  .onUserInteraction,
                                                          validator: (value) {
                                                            if (value.length ==
                                                                0) {
                                                              return "Tidak Boleh Kosong";
                                                            }
                                                            return null;
                                                          },
                                                          controller:
                                                              cSingkatan,
                                                          decoration: InputDecoration(
                                                              labelText:
                                                                  "Singkatan(Optional)",
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              13))),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SmartSelect<
                                                        QueryDocumentSnapshot>.single(
                                                    modalFilterAuto: true,
                                                    modalFilter: true,
                                                    modalFilterHint:
                                                        "Cari Guru",
                                                    title:
                                                        "Pilih Kepala Program",
                                                    choiceItems:
                                                        pilihKepalaProgramChoice,
                                                    value: selectedGuruValue,
                                                    onChange: (value) {
                                                      selectedGuruValue =
                                                          value.value;
                                                    }),
                                                CupertinoButton(
                                                  child: (state
                                                          is OnAddJurusanLoading)
                                                      ? CircularProgressIndicator()
                                                      : Txt("Buat Jurusan"),
                                                  color: Colors.lightBlue,
                                                  onPressed: () {
                                                    keyForm.currentState.save();
                                                    if (keyForm.currentState
                                                        .validate()) {
                                                      if (selectedGuruValue ==
                                                          null) {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    AlertDialog(
                                                                      title: Text(
                                                                          "Mohon Lengkapi Semua Form Yang Ada"),
                                                                    ));
                                                      } else {
                                                        bloc.add(AddJurusan(
                                                            cNamaJurusan.text,
                                                            cSingkatan.text,
                                                            selectedGuruValue.get(
                                                                "Nama Lengkap"),
                                                            selectedGuruValue
                                                                .id));
                                                      }
                                                    }
                                                    // Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                        style: ParentStyle()
                                          ..borderRadius(all: 20)
                                          ..padding(vertical: 20),
                                      ),
                                    ),
                                context: context)
                            .then((value) {
                          cNamaJurusan = TextEditingController();
                          cSingkatan = TextEditingController();
                          selectedGuruValue = null;
                        });
                      }
                    },
                    child: Card(
                        child: ListTile(
                      title: Text("Buat Jurusan"),
                      leading: Icon(Icons.plus_one),
                    )),
                  ),
                  onTap: () {
                    bloc.add(GetGuruForKaprog());
                  }),
              Container(
                color: Colors.blueAccent[100],
                child: Center(
                    child: Text(
                  "Kelas",
                  style: TextStyle(fontSize: 20),
                )),
              ),
              GestureDetector(
                child: BlocListener<MasterconfigurationBloc,
                    MasterconfigurationState>(
                  listener: (context, state) {
                    if (state is OnAddKelasSucceded) {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                              title: Text("Kelas Berhasil Ditambahkan"),
                              content: Container(
                                  height: 100,
                                  width: 100,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: state.result.length,
                                    itemBuilder: (context, i) => Text(
                                        state.result[i] + " Berhasil Dibuat"),
                                  ))));
                    }
                    if (state is OnGetJurusanError) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Error Terdeteksi"),
                                content: Text(state.messageError),
                              ));
                    }
                    if (state is OnAddKelasError) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Error Terdeteksi"),
                                content: Text(state.errorMessage),
                              ));
                    }
                    if (state is OnGetJurusanSucceded) {
                      TextEditingController cJumlahTingkatan =
                          TextEditingController();
                      TextEditingController cJumlahKelasPerTingkatan =
                          TextEditingController();
                      QueryDocumentSnapshot selectedJurusanValue;
                      GlobalKey<FormState> formJurusanKey = GlobalKey();
                      List<S2Choice<QueryDocumentSnapshot>> pilihJurusanItems =
                          state.result.docs
                              .map((e) => S2Choice<QueryDocumentSnapshot>(
                                  title: e.get("Nama Jurusan"), value: e))
                              .toList();
                      showDialog(
                          builder: (context) => Dialog(
                                child: Parent(
                                  child: Container(
                                      child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Txt(
                                            "Buat Kelas",
                                            style: TxtStyle()
                                              ..fontSize(20)
                                              ..padding(bottom: 10),
                                          ),
                                          Container(
                                            color: Colors.grey,
                                            height: 3,
                                          ),
                                          Parent(
                                            style: ParentStyle()
                                              ..padding(all: 10),
                                            child: SmartSelect<
                                                    QueryDocumentSnapshot>.single(
                                                modalFilterAuto: true,
                                                modalFilter: true,
                                                modalFilterHint: "Cari Jurusan",
                                                title: "Pilih Jurusan",
                                                choiceItems: pilihJurusanItems,
                                                value: selectedJurusanValue,
                                                onChange: (value) {
                                                  selectedJurusanValue =
                                                      value.value;
                                                }),
                                          ),
                                          Form(
                                            key: formJurusanKey,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            child: Column(
                                              children: [
                                                Parent(
                                                  style: ParentStyle()
                                                    ..padding(all: 10),
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value.length == 0) {
                                                        return "Tidak Boleh Kosong";
                                                      }
                                                      if (value.length == 1) {
                                                        return null;
                                                      } else {
                                                        return "Minimal 1 Angka";
                                                      }
                                                    },
                                                    controller:
                                                        cJumlahTingkatan,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                        labelText:
                                                            "Jumlah Tingkatan",
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        13))),
                                                  ),
                                                ),
                                                Parent(
                                                  style: ParentStyle()
                                                    ..padding(all: 10),
                                                  child: TextFormField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    validator: (value) {
                                                      if (value.length == 0) {
                                                        return "Tidak Boleh Kosong";
                                                      }
                                                      if (value.length == 1) {
                                                        return null;
                                                      } else {
                                                        return "Minimal 1 Angka";
                                                      }
                                                    },
                                                    controller:
                                                        cJumlahKelasPerTingkatan,
                                                    decoration: InputDecoration(
                                                        labelText:
                                                            "Jumlah Kelas per Tingkatan",
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        13))),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          CupertinoButton(
                                            child: Txt("Buat Kelas"),
                                            color: Colors.lightBlue,
                                            onPressed: () {
                                              formJurusanKey.currentState
                                                  .save();
                                              if (formJurusanKey.currentState
                                                  .validate()) {
                                                if (selectedJurusanValue ==
                                                    null) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          Dialog(
                                                            child: Text(
                                                                "Pilih Jurusan Terlebih Dahulu"),
                                                          ));
                                                }

                                                bloc.add(AddKelas(
                                                    selectedJurusanValue
                                                        .data()["Singkatan"],
                                                    cJumlahTingkatan.text,
                                                    cJumlahKelasPerTingkatan
                                                        .text,
                                                    selectedJurusanValue
                                                        .get("Nama Jurusan")));
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                    ],
                                  )),
                                  style: ParentStyle()
                                    ..borderRadius(all: 20)
                                    ..padding(vertical: 20),
                                ),
                              ),
                          context: context);
                    }
                  },
                  child: Card(
                      child: ListTile(
                    title: Text("Buat Kelas"),
                    leading: Icon(Icons.plus_one),
                  )),
                ),
                onTap: () {
                  bloc.add(GetJurusanAll());
                },
              ),
              GestureDetector(
                child: BlocListener<MasterconfigurationBloc,
                    MasterconfigurationState>(
                  listener: (context, state) {
                    if (state is OnSetWaliKelasSucceded) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Wali Kelas Berhasil Ditambahkan"),
                              ));
                    }
                    if (state is OnSetWaliKelasError) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Error Terdeteksi"),
                                content: Text(state.errorMessage),
                              ));
                    }
                    if (state is OnGetKelasForWaliKelasError) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Error Terdeteksi"),
                                content: Text(state.errorMessage),
                              ));
                    }
                    if (state is OnGetKelasForWaliKelasSucceded) {
                      List<S2Choice<QueryDocumentSnapshot>> choiceItemsKelas =
                          [];
                      QueryDocumentSnapshot selectedItemKelas;
                      List<S2Choice<QueryDocumentSnapshot>> choiceItemsGuru =
                          [];
                      QueryDocumentSnapshot selectedItemGuru;
                      choiceItemsKelas = state.mapQuerySnapshot["Kelas"].docs
                          .map<S2Choice<QueryDocumentSnapshot>>((e) =>
                              S2Choice<QueryDocumentSnapshot>(
                                  title: e.get("Nama Kelas"), value: e))
                          .toList();
                      choiceItemsGuru = state.mapQuerySnapshot["Guru"].docs
                          .map<S2Choice<QueryDocumentSnapshot>>((e) =>
                              S2Choice<QueryDocumentSnapshot>(
                                  title: e.get("Nama Lengkap"),
                                  subtitle: "Id: " + e.id,
                                  value: e))
                          .toList();
                      showDialog(
                          builder: (context) => Dialog(
                                child: Card(
                                  child: Parent(
                                    child: Container(
                                        child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Txt(
                                          "Wali Kelas",
                                          style: TxtStyle()
                                            ..fontSize(20)
                                            ..padding(bottom: 10),
                                        ),
                                        Container(
                                          color: Colors.grey,
                                          height: 3,
                                        ),
                                        Parent(
                                            style: ParentStyle()
                                              ..padding(all: 10),
                                            child: SmartSelect.single(
                                                modalFilter: true,
                                                modalFilterAuto: true,
                                                modalFilterHint: "Cari Kelas",
                                                title: "Pilih Kelas",
                                                choiceItems: choiceItemsKelas,
                                                value: selectedItemKelas,
                                                onChange: (value) {
                                                  selectedItemKelas =
                                                      value.value;
                                                })),
                                        Card(
                                          child: Parent(
                                            style: ParentStyle()
                                              ..padding(all: 10),
                                            child: SmartSelect.single(
                                                modalFilter: true,
                                                modalFilterAuto: true,
                                                modalFilterHint: "Cari Guru",
                                                title: "Pilih Guru",
                                                choiceItems: choiceItemsGuru,
                                                value: selectedItemGuru,
                                                onChange: (value) {
                                                  selectedItemGuru =
                                                      value.value;
                                                }),
                                          ),
                                        ),
                                        CupertinoButton(
                                          child: Txt("Set Wali Kelas"),
                                          color: Colors.lightBlue,
                                          onPressed: () {
                                            if (selectedItemKelas != null &&
                                                selectedItemGuru != null) {
                                              Navigator.pop(context);
                                              bloc.add(SetWaliKelas(
                                                  selectedItemKelas.id,
                                                  selectedItemKelas
                                                      .get("Nama Kelas"),
                                                  selectedItemGuru
                                                      .get("Nama Lengkap"),
                                                  selectedItemGuru.id));
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) => Dialog(
                                                      child: Text(
                                                          "Form Tidak Boleh Ada Yang Kosong")));
                                            }
                                          },
                                        )
                                      ],
                                    )),
                                    style: ParentStyle()
                                      ..borderRadius(all: 20)
                                      ..padding(vertical: 20),
                                  ),
                                ),
                              ),
                          context: context);
                    }
                  },
                  child: Card(
                      child: ListTile(
                    title: Text("Wali Kelas"),
                    leading: Icon(Icons.plus_one),
                  )),
                ),
                onTap: () {
                  bloc.add(GetKelasForWaliKelas());
                },
              ),
              Container(
                color: Colors.blueAccent[100],
                child: Center(
                    child: Text(
                  "Permission",
                  style: TextStyle(fontSize: 20),
                )),
              ),
              GestureDetector(
                child: Card(
                    child: ListTile(
                  title: Text("All Permission"),
                  leading: Icon(Icons.plus_one),
                )),
                onTap: () {},
              ),
              Container(
                color: Colors.blueAccent[100],
                child: Center(
                    child: Text(
                  "Pelajaran",
                  style: TextStyle(fontSize: 20),
                )),
              ),
              GestureDetector(
                child: BlocListener<MasterconfigurationBloc,
                    MasterconfigurationState>(
                  listener: (context, state) {
                    if (state is OnAddMataPelajaranSucceded) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title:
                                    Text("Mata Pelajaran Berhasil Ditambahkan"),
                              ));
                    }
                    if (state is OnAddMataPelajaranError) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Error Terdeteksi"),
                                content: Text(state.errorMessage),
                              ));
                    }
                  },
                  child: Card(
                      child: ListTile(
                    title: Text("Buat Pelajaran"),
                    leading: Icon(Icons.plus_one),
                  )),
                ),
                onTap: () {
                  TextEditingController cNamaMataPelajaran =
                      TextEditingController();
                  GlobalKey<FormState> _myKey = GlobalKey();
                  showDialog(
                      builder: (context) => Dialog(
                            child: Card(
                              child: Parent(
                                child: Container(
                                    child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Txt(
                                      "Buat Mata Pelajaran Baru",
                                      style: TxtStyle()
                                        ..fontSize(20)
                                        ..padding(bottom: 10),
                                    ),
                                    Container(
                                      color: Colors.grey,
                                      height: 3,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Form(
                                      key: _myKey,
                                      child: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: cNamaMataPelajaran,
                                        validator: (value) {
                                          if (value.length == 0) {
                                            return "Tidak Boleh Kosong";
                                          }
                                          if (value.length <= 2) {
                                            return "Minimal 3 Angka";
                                          } else {
                                            return null;
                                          }
                                        },
                                        decoration: InputDecoration(
                                            labelText: "Nama Matapelajaran",
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(13))),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    CupertinoButton(
                                      child: Text("Buat Matapelajaran"),
                                      color: Colors.lightBlue,
                                      onPressed: () {
                                        _myKey.currentState.save();
                                        if (_myKey.currentState.validate()) {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) => AlertDialog(
                                                    title: Text("Konfirmasi"),
                                                    actions: [
                                                      CupertinoButton(
                                                        child: Text("Ok"),
                                                        color: Colors.lightBlue,
                                                        onPressed: () {
                                                          bloc.add(AddMataPelajaran(
                                                              cNamaMataPelajaran
                                                                  .text));
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                      CupertinoButton(
                                                        child: Text("Batal"),
                                                        color: Colors.red,
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ),
                                                    ],
                                                  )).then((value) {
                                            Navigator.pop(context);
                                          });
                                        }
                                      },
                                    )
                                  ],
                                )),
                                style: ParentStyle()
                                  ..borderRadius(all: 20)
                                  ..padding(vertical: 20),
                              ),
                            ),
                          ),
                      context: context);
                },
              ),
            ],
          )),
        ),
      ),
    );
  }
}
