import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:skensa/Hive%20Databases/Models/SoalModel.dart';
import 'package:skensa/View/Guru/BuatKuisView.dart';
import 'package:skensa/View/Guru/TugasOpenGuruView.dart';
import 'package:skensa/bloc/tugasguru_bloc.dart';

class TugasGuruView extends StatelessWidget {
  String namaMataPelajaran;
  Map<String, dynamic> guru;
  TugasGuruView(this.namaMataPelajaran, this.guru);
  TugasguruBloc tugasguruBloc = TugasguruBloc();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TugasguruBloc>(
      create: (context) => tugasguruBloc,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          isExtended: true,
          onPressed: () {
            TextEditingController cJumlahSoal = TextEditingController();
            TextEditingController cJumlahJawaban = TextEditingController();
            GlobalKey<FormState> keyForm = GlobalKey();
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text("Konfigurasi Kuis"),
                      content: Form(
                        key: keyForm,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: cJumlahSoal,
                              decoration:
                                  InputDecoration(labelText: "Jumlah Soal"),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: cJumlahJawaban,
                              decoration:
                                  InputDecoration(labelText: "Jumlah Jawaban"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CupertinoButton(
                              child: Text("Generate"),
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BuatKuisView(
                                            int.parse(cJumlahSoal.text),
                                            int.parse(cJumlahJawaban.text),
                                            namaMataPelajaran,
                                            guru)));
                              },
                              color: Colors.lightBlue,
                            )
                          ],
                        ),
                      ),
                    ));
          },
          label: Text("Buat Kuis"),
        ),
        appBar: AppBar(
          title: GestureDetector(
              onTap: () {
                Hive.box<SoalModel>("SoalDb").clear();
              },
              child: Text("Tugas Yang Sudah Dibuat")),
          actions: [
            BlocListener<TugasguruBloc, TugasguruState>(
                listener: (context, state) async {
                  if (state is OnGetTugasLoading) {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => Dialog(
                              child: CircularProgressIndicator(),
                            ));
                  }
                  if (state is OnGetTugasSucceded) {
                    print("State: OnGetTugasSucceded");

                    Navigator.pop(context);
                    Box<SoalModel> boxSoalDb = Hive.box<SoalModel>("SoalDb");
                    print("State result Lengt: " +
                        state.result.length.toString());
                    await boxSoalDb.clear();

                    for (var i = 0; i < state.result.length; i++) {
                      boxSoalDb.add(SoalModel(
                          state.result[i]["Data"]["Nama Tugas"],
                          state.result[i]["Data"]["Guru"],
                          state.result[i]["Data"]["Kelas"],
                          state.result[i]["Data"]["Nama Mata Pelajaran"],
                          state.result[i]["Data"]["Soal"],
                          state.result[i]["Data"]["Tipe"],
                          state.result[i]["Data"]["Waktu Kuis"],
                          state.result[i]["Id"]));
                    }
                  }
                  if (state is OnGetTugasError) {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Error Terdeteksi"),
                              content: Text(state.errorMessage),
                            ));
                  }
                },
                child: IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      if (Hive.isBoxOpen("SoalDb")) {
                        tugasguruBloc.add(GetTugas(
                            namaMataPelajaran,
                            (guru["Path"] as String).split("/").last,
                            guru["Nama Lengkap"]));
                      }
                    }))
          ],
          centerTitle: true,
        ),
        body: Container(
          child: FutureBuilder(
              future: Hive.openBox<SoalModel>("SoalDb"),
              builder: (context, AsyncSnapshot<Box<SoalModel>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Center(child: CircularProgressIndicator());
                    break;
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                    break;
                  case ConnectionState.active:
                    return Center(child: CircularProgressIndicator());
                    break;
                  case ConnectionState.done:
                    return StreamBuilder(
                        stream: snapshot.data.watch(),
                        builder:
                            (context, AsyncSnapshot<BoxEvent> snapshotBox) {
                          if (snapshot.data.length > 0) {
                            return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, i) => Card(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TugasOpenGuruView(
                                                          snapshot.data
                                                              .getAt(i),
                                                          guru)));
                                        },
                                        child: ListTile(
                                          leading: Icon(Icons.assignment),
                                          title: Text("Nama Tugas: " +
                                              snapshot.data.getAt(i).namaTugas),
                                          subtitle: Row(
                                            children: List<Widget>.generate(
                                                snapshot.data
                                                        .getAt(i)
                                                        .kelas
                                                        .length +
                                                    1,
                                                (index) => (index == 0)
                                                    ? Text("Untuk Kelas: ")
                                                    : Text(snapshot.data
                                                                    .getAt(i)
                                                                    .kelas[
                                                                index - 1]
                                                            ["Nama Kelas"] +
                                                        " ")),
                                          ),
                                        ),
                                      ),
                                    ));
                          } else {
                            return Center(
                              child: Text("No Data"),
                            );
                          }
                        });
                    break;
                }
              }),
        ),
      ),
    );
  }
}
