import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:division/division.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skensa/bloc/gurumanagement_bloc.dart';
import 'package:skensa/bloc/hydrateduser_bloc.dart';
import 'package:smart_select/smart_select.dart';

class GuruManagementView extends StatelessWidget {
  Map<String, dynamic> guru;
  HydrateduserBloc userBloc;

  GuruManagementView(this.guru, this.userBloc);
  GurumanagementBloc bloc = GurumanagementBloc();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GurumanagementBloc>(
          create: (context) => bloc,
        ),
        BlocProvider<HydrateduserBloc>(
          create: (context) => HydrateduserBloc(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text("Account And Management"),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Card(
                      child: ListTile(
                        title: Text("Nama Lengkap : " + guru["Nama Lengkap"]),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text("Nama Pengguna : " + guru["Nama Pengguna"]),
                      ),
                    ),
                    (guru["Wali Kelas"] != null)
                        ? BlocConsumer<GurumanagementBloc, GurumanagementState>(
                            listener: (context, state) {
                            if (state is OnAddMataPelajaranKelasError) {
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                      title: Text("Error Terdeteksi"),
                                      content: Text(state.errorMessage)));
                            }
                            if (state is OnAddMataPelajaranKelasSucceded) {
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                      title: Text(
                                          "Mata Pelajaran Berhasil Ditambahkan")));
                            }
                            if (state is OnAddMataPelajaranKelasLoading) {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) =>
                                      AlertDialog(title: Text("Loading...")));
                            }
                            if (state is OnGetInfoKelasError) {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text("Error Terdeteksi"),
                                        content: Text(state.errorMessage),
                                      ));
                            }
                          }, builder: (context, state) {
                            if (state is OnGetInfoKelasSucceded) {
                              QuerySnapshot allGuru = state.allGuru;
                              List<S2Choice<QueryDocumentSnapshot>>
                                  choiceItemsGuru;
                              QueryDocumentSnapshot selectedItemGuru;
                              List<Widget> listPelajaranKelas = [];
                              List<QueryDocumentSnapshot>
                                  selcetedItemsPelajaran = [];
                              List<Widget> unregisteredPelajaran = [];
                              List<Map<String, dynamic>> listMataPelajaran = [];
                              List<S2Choice<QueryDocumentSnapshot>>
                                  choiceItemsPelajaran = [];
                              choiceItemsGuru = allGuru.docs
                                  .map<S2Choice<QueryDocumentSnapshot>>(
                                      (guru) => S2Choice<QueryDocumentSnapshot>(
                                          title: guru.get("Nama Lengkap"),
                                          subtitle: "Id: " + guru.id,
                                          value: guru))
                                  .toList();
                              if (state.allPelajaran.docs.isNotEmpty) {
                                if (state.result.get("Mata Pelajaran") !=
                                    null) {
                                  listPelajaranKelas = (state.result
                                          .get("Mata Pelajaran") as List)
                                      .map<Widget>((e) => CupertinoButton(
                                            child:
                                                Text(e["Nama Mata Pelajaran"]),
                                            padding: EdgeInsets.fromLTRB(
                                                10, 5, 10, 5),
                                            color: Colors.red,
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                      title: Text(
                                                          "Detail Selengkapnya"),
                                                      content: (e["Pengajar"] ==
                                                              null)
                                                          ? Text(
                                                              "Pengajar : Null")
                                                          : Text("Pengajar : " +
                                                              e["Pengajar"][
                                                                  "Nama Lengkap"])));
                                            },
                                          ))
                                      .toList();
                                }
                                //Filter Pelajaran
                                List<QueryDocumentSnapshot> allPelajaran =
                                    state.allPelajaran.docs;
                                List<QueryDocumentSnapshot> pelajaranSame = [];
                                allPelajaran.forEach((pelajaran) {
                                  for (var i = 0;
                                      i <
                                          state.result
                                              .get("Mata Pelajaran")
                                              .length;
                                      i++) {
                                    if (pelajaran.get("Nama Mata Pelajaran") ==
                                        state.result.get("Mata Pelajaran")[i]
                                            ["Nama Mata Pelajaran"]) {
                                      pelajaranSame.add(pelajaran);
                                    }
                                  }
                                });
                                pelajaranSame.forEach((element) {
                                  allPelajaran.remove(element);
                                });
                                allPelajaran.forEach((element) {
                                  choiceItemsPelajaran.add(
                                      S2Choice<QueryDocumentSnapshot>(
                                          title: element
                                              .get("Nama Mata Pelajaran"),
                                          value: element));
                                });

                                // for (var i = 0;
                                //     i < state.allPelajaran.docs.length;
                                //     i++) {
                                //   for (var i1 = 0;
                                //       i1 <
                                //           (state.result.get("Mata Pelajaran")
                                //                   as List)
                                //               .length;
                                //       i1++) {
                                //     if (state.allPelajaran.docs[i]
                                //             .get("Nama Mata Pelajaran") !=
                                //         (state.result.get("Mata Pelajaran")
                                //                 as List)[i1]
                                //             ["Nama Mata Pelajaran"]) {
                                //       choiceItemsPelajaran.add(
                                //           S2Choice<QueryDocumentSnapshot>(
                                //               title: state.allPelajaran.docs[i]
                                //                   .get("Nama Mata Pelajaran"),
                                //               value:
                                //                   state.allPelajaran.docs[i]));
                                //     }
                                //   }
                                // }
                              }
                              return Card(
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                          child: Text("Wali Kelas : " +
                                              guru["Wali Kelas"]
                                                  ["Nama Kelas"])),
                                      CupertinoButton(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 5, 10, 5),
                                        child: Text("Hide"),
                                        color: Colors.lightBlue,
                                        onPressed: () {
                                          bloc.add(AddInitialState());
                                        },
                                      ),
                                    ],
                                  ),
                                  subtitle: StatefulBuilder(
                                    builder: (context, myState) => Column(
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          height: 3,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Txt("Kelas",
                                            style: TxtStyle()
                                              ..fontSize(20)
                                              ..padding(bottom: 10)
                                              ..alignment.center()),
                                        Container(
                                          color: Colors.grey,
                                          height: 3,
                                        ),
                                        Card(
                                          child: SmartSelect.single(
                                              modalTitle: "Pilih Ketua Kelas",
                                              tileBuilder: (context, value) =>
                                                  ListTile(
                                                    title: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                            child: Text(
                                                                "Ketua Kelas")),
                                                        CupertinoButton(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  10, 5, 10, 5),
                                                          child: (state.result.get(
                                                                      "Ketua Kelas") ==
                                                                  null)
                                                              ? Text(
                                                                  "Set Ketua Kelas")
                                                              : Text(
                                                                  "Ganti Ketua Kelas"),
                                                          color:
                                                              Colors.lightBlue,
                                                          onPressed: () {
                                                            value.showModal();
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                    subtitle: Text(state.result
                                                        .get("Ketua Kelas")
                                                        .toString()),
                                                  ),
                                              title: "Ketua Kelas",
                                              choiceItems: [],
                                              value: null,
                                              onChange: (value) {}),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Card(
                                          child: SmartSelect<
                                                  QueryDocumentSnapshot>.multiple(
                                              tileBuilder: (context, value) =>
                                                  ListTile(
                                                    title: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text("Pelajaran"),
                                                            IconButton(
                                                              iconSize: 30,
                                                              icon: Icon(Icons
                                                                  .add_box),
                                                              color: Colors
                                                                  .lightBlue,
                                                              onPressed: () {
                                                                value
                                                                    .showModal();
                                                              },
                                                            )
                                                          ],
                                                        ),
                                                        Container(
                                                          height: 2,
                                                          color: Colors.grey,
                                                        ),
                                                      ],
                                                    ),
                                                    subtitle: Wrap(
                                                      spacing: 10,
                                                      runSpacing: 10,
                                                      direction:
                                                          Axis.horizontal,
                                                      children:
                                                          listPelajaranKelas,
                                                    ),
                                                  ),
                                              title: "Pelajaran",
                                              choiceItems: choiceItemsPelajaran,
                                              value: selcetedItemsPelajaran,
                                              onChange: (value) {
                                                selcetedItemsPelajaran =
                                                    value.value;
                                                value.value = [];
                                                print(
                                                    "choiceItemsPelajaran : " +
                                                        choiceItemsPelajaran
                                                            .length
                                                            .toString());
                                                print(
                                                    "selcetedItemsPelajaran : " +
                                                        selcetedItemsPelajaran
                                                            .length
                                                            .toString());
                                                if (selcetedItemsPelajaran
                                                        .length >
                                                    0) {
                                                  unregisteredPelajaran.addAll(
                                                      selcetedItemsPelajaran
                                                          .map((e) {
                                                    return Card(
                                                      child: ListTile(
                                                        title: Text(
                                                            "Mata Pelajaran : " +
                                                                e.get(
                                                                    "Nama Mata Pelajaran")),
                                                        subtitle: SmartSelect<
                                                                QueryDocumentSnapshot>.single(
                                                            title: "Pilih Guru",
                                                            choiceItems:
                                                                choiceItemsGuru,
                                                            value:
                                                                selectedItemGuru,
                                                            tileBuilder: (context,
                                                                    myWidget) =>
                                                                ListTile(
                                                                  title: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Flexible(
                                                                          child:
                                                                              Text("Pilih Guru")),
                                                                      CupertinoButton(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            10,
                                                                            5,
                                                                            10,
                                                                            5),
                                                                        child: (myWidget.value !=
                                                                                null)
                                                                            ? Text(myWidget.value.get("Nama Pengguna"))
                                                                            : Text("Select One"),
                                                                        color: Colors
                                                                            .lightBlue,
                                                                        onPressed:
                                                                            () {
                                                                          if (myWidget.value ==
                                                                              null) {
                                                                            myWidget.showModal();
                                                                          }
                                                                        },
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                            onChange: (value) {
                                                              if (value.value !=
                                                                  null) {
                                                                listMataPelajaran
                                                                    .add({
                                                                  "Nama Mata Pelajaran":
                                                                      e.get(
                                                                          "Nama Mata Pelajaran"),
                                                                  "Pengajar": {
                                                                    "Nama Lengkap": value
                                                                        .value
                                                                        .get(
                                                                            "Nama Lengkap"),
                                                                    "Id": value
                                                                        .value
                                                                        .id
                                                                  }
                                                                });
                                                              }
                                                              print(listMataPelajaran
                                                                  .toString());
                                                            }),
                                                      ),
                                                    );
                                                  }).toList());
                                                }
                                                //Clear Choised Item
                                                for (var i = 0;
                                                    i <
                                                        selcetedItemsPelajaran
                                                            .length;
                                                    i++) {
                                                  choiceItemsPelajaran.remove(
                                                      S2Choice<
                                                              QueryDocumentSnapshot>(
                                                          title: selcetedItemsPelajaran[
                                                                  i]
                                                              .get(
                                                                  "Nama Mata Pelajaran"),
                                                          value:
                                                              selcetedItemsPelajaran[
                                                                  i]));
                                                }
                                                selcetedItemsPelajaran = [];
                                                myState(() {});

                                                // selcetedItemsPelajaran =
                                                //     value.value;
                                                // print(selcetedItemsPelajaran
                                                //     .toString());
                                                // if (selcetedItemsPelajaran
                                                //         .length !=
                                                //     0) {
                                                //   bloc.add(AddMataPelajaranKelas(
                                                //       state.result.id,
                                                //       selcetedItemsPelajaran));
                                                // }
                                              }),
                                        ),
                                        ListView.builder(
                                          itemCount:
                                              unregisteredPelajaran.length,
                                          shrinkWrap: true,
                                          physics: ClampingScrollPhysics(),
                                          itemBuilder: (context, i) =>
                                              unregisteredPelajaran[i],
                                        ),
                                        (unregisteredPelajaran.length > 0)
                                            ? CupertinoButton(
                                                child: Text("Simpan"),
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 5, 10, 5),
                                                color: Colors.lightBlue,
                                                onPressed: () {
                                                  if (state
                                                      is! OnAddMataPelajaranKelasLoading) {
                                                    bloc.add(
                                                        AddMataPelajaranKelas(
                                                            state.result.get(
                                                                "Nama Kelas"),
                                                            state.result.id,
                                                            listMataPelajaran));
                                                  }
                                                },
                                              )
                                            : SizedBox()
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Card(
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                        child: Text("Wali Kelas : " +
                                            guru["Wali Kelas"]["Nama Kelas"])),
                                    BlocConsumer<GurumanagementBloc,
                                        GurumanagementState>(
                                      listener: (context, state) {
                                        if (state is OnGetInfoKelasSucceded) {
                                          // showDialog(
                                          //     builder: (context) => Dialog(
                                          //           child: Parent(
                                          //             child: Container(
                                          //               child: ListView(
                                          //                 shrinkWrap: true,
                                          //                 children: [
                                          //                   Txt("Kelas",
                                          //                       style: TxtStyle()
                                          //                         ..fontSize(20)
                                          //                         ..padding(
                                          //                             bottom: 10)
                                          //                         ..alignment
                                          //                             .center()),
                                          //                   Container(
                                          //                     color: Colors.grey,
                                          //                     height: 3,
                                          //                   ),
                                          //                   Card(
                                          //                     child: SmartSelect
                                          //                         .single(
                                          //                             modalTitle:
                                          //                                 "Pilih Ketua Kelas",
                                          //                             tileBuilder:
                                          //                                 (context,
                                          //                                         value) =>
                                          //                                     ListTile(
                                          //                                       title: Row(
                                          //                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //                                         children: [
                                          //                                           Flexible(child: Text("Ketua Kelas")),
                                          //                                           CupertinoButton(
                                          //                                             padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                          //                                             child: (state.result.get("Ketua Kelas") == null) ? Text("Set Ketua Kelas") : Text("Ganti Ketua Kelas"),
                                          //                                             color: Colors.lightBlue,
                                          //                                             onPressed: () {
                                          //                                               value.showModal();
                                          //                                             },
                                          //                                           )
                                          //                                         ],
                                          //                                       ),
                                          //                                       subtitle: Text(state.result.get("Ketua Kelas").toString()),
                                          //                                     ),
                                          //                             title:
                                          //                                 "Ketua Kelas",
                                          //                             choiceItems: [],
                                          //                             value: null,
                                          //                             onChange:
                                          //                                 (value) {}),
                                          //                   ),
                                          //                   SizedBox(
                                          //                     height: 10,
                                          //                   ),
                                          //                   Card(
                                          //                     child: SmartSelect<
                                          //                             String>.multiple(
                                          //                         tileBuilder:
                                          //                             (context,
                                          //                                     value) =>
                                          //                                 ListTile(
                                          //                                   title:
                                          //                                       Column(
                                          //                                     children: [
                                          //                                       Row(
                                          //                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //                                         children: [
                                          //                                           Text("Pelajaran"),
                                          //                                           IconButton(
                                          //                                             iconSize: 30,
                                          //                                             icon: Icon(Icons.add_box),
                                          //                                             color: Colors.lightBlue,
                                          //                                             onPressed: () {
                                          //                                               value.showModal();
                                          //                                             },
                                          //                                           )
                                          //                                         ],
                                          //                                       ),
                                          //                                       Container(
                                          //                                         height: 2,
                                          //                                         color: Colors.grey,
                                          //                                       ),
                                          //                                     ],
                                          //                                   ),
                                          //                                   subtitle:
                                          //                                       Wrap(
                                          //                                     spacing:
                                          //                                         10,
                                          //                                     runSpacing:
                                          //                                         10,
                                          //                                     direction:
                                          //                                         Axis.horizontal,
                                          //                                     children:
                                          //                                         listPelajaranKelas,
                                          //                                   ),
                                          //                                 ),
                                          //                         title:
                                          //                             "Pelajaran",
                                          //                         choiceItems:
                                          //                             choiceItemsPelajaran,
                                          //                         value:
                                          //                             selcetedItemsPelajaran,
                                          //                         onChange:
                                          //                             (value) {
                                          //                           selcetedItemsPelajaran =
                                          //                               value
                                          //                                   .value;
                                          //                           print(selcetedItemsPelajaran
                                          //                               .toString());
                                          //                           if (selcetedItemsPelajaran
                                          //                                   .length !=
                                          //                               0) {
                                          //                             bloc.add(AddMataPelajaranKelas(
                                          //                                 state
                                          //                                     .result
                                          //                                     .id,
                                          //                                 selcetedItemsPelajaran));
                                          //                           }
                                          //                         }),
                                          //                   )
                                          //                 ],
                                          //               ),
                                          //             ),
                                          //             style: ParentStyle()
                                          //               ..borderRadius(all: 20)
                                          //               ..padding(vertical: 20),
                                          //           ),
                                          //         ),
                                          //     context: context);
                                        }
                                      },
                                      builder: (context, state) =>
                                          CupertinoButton(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 5, 10, 5),
                                        child: (state is OnGetInfoKelasLoading)
                                            ? CircularProgressIndicator(
                                                backgroundColor: Colors.white,
                                              )
                                            : Text("Atur Kelas"),
                                        color: Colors.lightBlue,
                                        onPressed: () {
                                          if (state is! OnGetInfoKelasLoading) {
                                            BlocProvider.of<GurumanagementBloc>(
                                                    context)
                                                .add(GetInfoKelas(
                                                    guru["Wali Kelas"]["Id"]));
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                        : SizedBox(),
                    BlocConsumer<GurumanagementBloc, GurumanagementState>(
                        listener: (context, state) {
                      if (state is OnAddMataPelajaranGuruLoading) {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("Loading..."),
                                ));
                      }
                      if (state is OnAddMataPelajaranGuruError) {
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("Error Terdeteksi"),
                                  content: Text(state.errorMessage),
                                ));
                      }
                      if (state is OnAddMataPelajaranGuruSucceded) {
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text(
                                      "Mata Pelajaran Anda Berhasil Ditambahkan"),
                                ));
                      }
                    }, builder: (context, state) {
                      if (state is OnGetPropertyMengajarGuruSucceded) {
                        List<S2Choice<QueryDocumentSnapshot>>
                            choiceItemsPelajaran = [];
                        List<S2Choice<QueryDocumentSnapshot>> choiceItemsKelas =
                            [];
                        List<QueryDocumentSnapshot> choiceItemKelas = [];
                        QueryDocumentSnapshot choiceItemPelajaran;
                        Map<String, dynamic> complete = {};

                        if (state.allMataPelajaran != null) {
                          choiceItemsPelajaran = state.allMataPelajaran.docs
                              .map<S2Choice<QueryDocumentSnapshot>>((e) =>
                                  S2Choice<QueryDocumentSnapshot>(
                                      title: e.get("Nama Mata Pelajaran"),
                                      value: e))
                              .toList();
                        }

                        return Card(
                          child: Column(
                            children: [
                              ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    (guru["Mengajar"] != null)
                                        ? Flexible(
                                            child: Text("Mengajar : " +
                                                guru["Mengajar"]))
                                        : Flexible(
                                            child: Text(
                                                "Mengajar : Tidak Mengajar")),
                                    (guru["Mengajar"] != null)
                                        ? CupertinoButton(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 5, 10, 5),
                                            child:
                                                Text("Detail Pelajaran Saya"),
                                            color: Colors.lightBlue,
                                            onPressed: () {},
                                          )
                                        : CupertinoButton(
                                            color: Colors.lightGreen,
                                            onPressed: () {
                                              bloc.add(AddInitialState());
                                            },
                                            padding: EdgeInsets.fromLTRB(
                                                10, 5, 10, 5),
                                            child: Text("Hide"),
                                          )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 3,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Txt(
                                "Set Pelajaran Anda",
                                style: TxtStyle()..fontSize(20),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 3,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              StatefulBuilder(
                                builder: (context, myState) => Card(
                                  child: ListTile(
                                      title: SmartSelect.single(
                                          modalFilter: true,
                                          modalFilterAuto: true,
                                          title: "Pilih Mata Pelajaran Anda",
                                          choiceItems: choiceItemsPelajaran,
                                          value: choiceItemPelajaran,
                                          onChange: (value) {
                                            choiceItemsKelas = [];
                                            choiceItemKelas = [];
                                            choiceItemPelajaran = value.value;
                                            if (state.allKelas != null) {
                                              state.allKelas.docs
                                                  .forEach((element) {
                                                if (element.get(
                                                        "Mata Pelajaran") !=
                                                    null) {
                                                  for (var i = 0;
                                                      i <
                                                          (element.get(
                                                                      "Mata Pelajaran")
                                                                  as List)
                                                              .length;
                                                      i++) {
                                                    if ((element.get(
                                                                    "Mata Pelajaran")
                                                                as List)[i][
                                                            "Nama Mata Pelajaran"] ==
                                                        choiceItemPelajaran.get(
                                                            "Nama Mata Pelajaran")) {
                                                      choiceItemsKelas.add(S2Choice<
                                                              QueryDocumentSnapshot>(
                                                          title: element.get(
                                                              "Nama Kelas"),
                                                          group: (element.get(
                                                                      "Nama Kelas")
                                                                  as String)
                                                              .split(" ")
                                                              .first,
                                                          value: element));
                                                    }
                                                  }
                                                }
                                              });
                                            }
                                            myState(() {});
                                          }),
                                      subtitle: SmartSelect<
                                              QueryDocumentSnapshot>.multiple(
                                          title: "Pilih Kelas",
                                          modalFilter: true,
                                          modalFilterAuto: true,
                                          choiceGrouped: true,
                                          modalFilterHint: "Cari Kelas",
                                          choiceItems:
                                              (choiceItemPelajaran != null)
                                                  ? choiceItemsKelas
                                                  : [],
                                          value: choiceItemKelas,
                                          onChange: (value) {
                                            choiceItemKelas = value.value;
                                            List<Map<String, dynamic>>
                                                listKelas = [];

                                            for (var i = 0;
                                                i < choiceItemKelas.length;
                                                i++) {
                                              listKelas.add({
                                                "Nama Kelas": choiceItemKelas[i]
                                                    .get("Nama Kelas"),
                                                "Jurusan": choiceItemKelas[i]
                                                    .get("Jurusan"),
                                                "idKelas": choiceItemKelas[i]
                                                    .reference
                                                    .path
                                                    .split("/")
                                                    .last
                                              });
                                            }

                                            complete = {
                                              "Mata Pelajaran":
                                                  choiceItemPelajaran.get(
                                                      "Nama Mata Pelajaran"),
                                              "List Kelas": listKelas
                                            };
                                            print(complete.toString());
                                          })),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: CupertinoButton(
                                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Text("Tambah Pelajaran Saya"),
                                  color: Colors.lightBlue,
                                  onPressed: () {
                                    if (state
                                        is! OnAddMataPelajaranGuruLoading) {
                                      if (choiceItemPelajaran != null &&
                                          choiceItemKelas.length > 0) {
                                        bloc.add(AddMataPelajaranGuru(
                                            (guru["Path"] as String)
                                                .split("/")
                                                .last,
                                            guru["Nama Lengkap"],
                                            complete["Mata Pelajaran"],
                                            complete["List Kelas"]
                                                as List<Map<String, dynamic>>));
                                      }
                                    }
                                  },
                                ),
                              ),

                              // StatefulBuilder(
                              //   builder: (context, myState) => Card(
                              //       child: SmartSelect.single(
                              //           tileBuilder: (context,
                              //                   singleState) =>
                              //               ListTile(
                              //                 title: Row(
                              //                   mainAxisAlignment:
                              //                       MainAxisAlignment
                              //                           .spaceBetween,
                              //                   children: [
                              //                     Flexible(
                              //                         child: Text(
                              //                             "Pilih Mata Pelajaran Anda")),
                              //                     CupertinoButton(
                              //                       color: Colors.lightBlue,
                              //                       onPressed: () {
                              //                         singleState
                              //                             .showModal();
                              //                       },
                              //                       child: Flexible(
                              //                         child: Text(
                              //                             "Select One"),
                              //                       ),
                              //                       padding:
                              //                           EdgeInsets.fromLTRB(
                              //                               10, 5, 10, 5),
                              //                     )
                              //                   ],
                              //                 ),
                              //                 subtitle: SmartSelect<
                              //                         QueryDocumentSnapshot>.multiple(
                              //                     modalFilter: true,
                              //                     modalFilterAuto: true,
                              //                     choiceGrouped: true,
                              //                     choiceItems:
                              //                         (choiceItemPelajaran !=
                              //                                 null)
                              //                             ? choiceItemsKelas
                              //                             : [],
                              //                     title: "Pilih Kelas",
                              //                     value: choiceItemKelas,
                              //                     onChange: (value) {
                              //                       choiceItemKelas =
                              //                           value.value;
                              //                       List<
                              //                               Map<String,
                              //                                   dynamic>>
                              //                           listKelas = [];
                              //                       for (var i = 0;
                              //                           i <
                              //                               choiceItemKelas
                              //                                   .length;
                              //                           i++) {
                              //                         listKelas.add({
                              //                           "Nama Kelas":
                              //                               choiceItemKelas[
                              //                                       i]
                              //                                   .get(
                              //                                       "Nama Kelas"),
                              //                           "Jurusan":
                              //                               choiceItemKelas[
                              //                                       i]
                              //                                   .get(
                              //                                       "Jurusan"),
                              //                           "Path":
                              //                               choiceItemKelas[
                              //                                       i]
                              //                                   .reference
                              //                                   .path
                              //                         });
                              //                       }

                              //                       complete = {
                              //                         "Mata Pelajaran":
                              //                             choiceItemPelajaran
                              //                                 .get(
                              //                                     "Nama Mata Pelajaran"),
                              //                         "List Kelas":
                              //                             listKelas
                              //                       };
                              //                       print(complete
                              //                           .toString());
                              //                     }),
                              //               ),
                              //           title: "Pilih Mata Pelajaran Anda",
                              //           choiceItems: choiceItemsPelajaran,
                              //           value: choiceItemPelajaran,
                              //           onChange: (value) {
                              //             choiceItemPelajaran = value.value;
                              //             if (state.allKelas != null) {
                              //               // state.allKelas.docs
                              //               //     .forEach(
                              //               //         (element) {
                              //               //   if (element.get(
                              //               //           "Mata Pelajaran") !=
                              //               //       null) {
                              //               //     for (var i = 0;
                              //               //         i <
                              //               //             (element.get("Mata Pelajaran")
                              //               //                     as List)
                              //               //                 .length;
                              //               //         i++) {
                              //               //       if ((element.get("Mata Pelajaran")
                              //               //                   as List)[
                              //               //               i] ==
                              //               //           choiceItemPelajaran
                              //               //               .get(
                              //               //                   "Nama Mata Pelajaran")) {
                              //               //         choiceItemsKelas.add(S2Choice<
                              //               //                 QueryDocumentSnapshot>(
                              //               //             title:
                              //               //                 "kelas",
                              //               //             value:
                              //               //                 null));
                              //               //       }
                              //               //     }
                              //               //   }
                              //               // });
                              //               state.allKelas.docs
                              //                   .forEach((element) {
                              //                 choiceItemsKelas.add(S2Choice<
                              //                         QueryDocumentSnapshot>(
                              //                     title: element
                              //                         .get("Nama Kelas"),
                              //                     value: element));
                              //               });
                              //             }
                              //             myState(() {});
                              //           })),
                              // )
                            ],
                          ),
                        );
                      }
                      return Card(
                        child: Column(
                          children: [
                            ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  (guru["Mengajar"] != null)
                                      ? Flexible(
                                          child: Text("Mengajar : " +
                                              guru["Mengajar"]
                                                  .length
                                                  .toString() +
                                              " Mata Pelajaran"))
                                      : Flexible(
                                          child: Text(
                                              "Mengajar : Tidak Mengajar")),
                                  (guru["Mengajar"] != null)
                                      ? CupertinoButton(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 5, 10, 5),
                                          child: Text("Detail Pelajaran Saya"),
                                          color: Colors.lightBlue,
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (context) => AlertDialog(
                                                          title: Text(
                                                              "Detail Pelajaran"),
                                                          content: Container(
                                                              width: 300,
                                                              height: 300,
                                                              child: ListView
                                                                  .builder(
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemCount:
                                                                          (guru["Mengajar"] as List)
                                                                              .length,
                                                                      itemBuilder: (context,
                                                                              i) =>
                                                                          Card(
                                                                            child:
                                                                                ListTile(
                                                                              title: Text(guru["Mengajar"][i]["Nama Mata Pelajaran"]),
                                                                              subtitle: Text("Kelas: " + guru["Mengajar"][i]["Kelas"]["Nama Kelas"]),
                                                                            ),
                                                                          ))),
                                                        ));
                                          },
                                        )
                                      : CupertinoButton(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 5, 10, 5),
                                          child: (state
                                                  is OnGetPropertyMengajarGuruLoading)
                                              ? CircularProgressIndicator(
                                                  backgroundColor: Colors.white,
                                                )
                                              : Text("Saya Mengajar"),
                                          color: Colors.lightGreen,
                                          onPressed: () {
                                            if (state
                                                is! OnGetPropertyMengajarGuruLoading) {
                                              bloc.add(
                                                  GetPropertyMengajarGuru());
                                            }
                                          },
                                        )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    Card(
                      child: ListTile(
                        title:
                            BlocConsumer<HydrateduserBloc, HydrateduserState>(
                          listener: (context, state) {
                            if (state is OnUpdateDataGuruError) {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text("Error Terdeteksi"),
                                        content: Text(state.errorMessage),
                                      ));
                            }
                          },
                          builder: (context, state) => CupertinoButton(
                            child: (state is OnUpdateDataGuruLoading)
                                ? CircularProgressIndicator()
                                : Text("Update All Data"),
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            color: Colors.lightBlue,
                            onPressed: () {
                              if (state is! OnUpdateDataGuruLoading) {
                                BlocProvider.of<HydrateduserBloc>(context).add(
                                    UpdateDataGuru(
                                        guru["Email"], guru["Password"]));
                              }
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  borderRadius: BorderRadius.circular(0),
                  child: Text("Log Out"),
                  color: Colors.red,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Apakah Anda Yakin Untuk Keluar?"),
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Flexible(
                                    child: CupertinoButton(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 5, 10, 5),
                                      child: Text("OK"),
                                      color: Colors.red,
                                      onPressed: () {
                                        Navigator.pop(context);
                                        userBloc.add(SignOut());
                                      },
                                    ),
                                  ),
                                  Flexible(
                                    child: CupertinoButton(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 5, 10, 5),
                                      child: Text("Batal"),
                                      color: Colors.lightBlue,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
