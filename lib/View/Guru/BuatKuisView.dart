import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skensa/Services/FireStoreService.dart';
import 'package:skensa/bloc/buatkuis_bloc.dart';
import 'package:smart_select/smart_select.dart';

class BuatKuisView extends StatefulWidget {
  int jumlahSoal;
  int jumlahPilihanJawaban;
  String namaMataPelajaran;
  Map<String, dynamic> guru;
  BuatKuisView(this.jumlahSoal, this.jumlahPilihanJawaban,
      this.namaMataPelajaran, this.guru);

  @override
  _BuatKuisViewState createState() => _BuatKuisViewState();
}

class _BuatKuisViewState extends State<BuatKuisView> {
  List<String> pilihanJawaban = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P"
  ];
  int page = 1;
  TextEditingController cSoal = TextEditingController();
  List<TextEditingController> ctr = List<TextEditingController>.generate(
      4, (index) => TextEditingController());
  List<String> allJawaban = [];
  String jawabanBenar = "";
  List<Map<String, dynamic>> isiKuis = [];
  BuatkuisBloc kuisBloc = BuatkuisBloc();

  @override
  Widget build(BuildContext context) {
    print("isiKuis : " + isiKuis.length.toString());
    if (isiKuis.length < page) {
      cSoal = TextEditingController();
      ctr = List<TextEditingController>.generate(
          4, (index) => TextEditingController());
    } else {
      cSoal.text = isiKuis[page - 1]["Soal"];
      for (var i = 0; i < widget.jumlahPilihanJawaban; i++) {
        ctr[i].text = isiKuis[page - 1]["Pilihan Jawaban"][i];
      }
      jawabanBenar = isiKuis[page - 1]["Jawaban Benar"];
    }
    GlobalKey<FormState> keyForm = GlobalKey();
    return WillPopScope(
      onWillPop: () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Keluar Dari Halaman Kuis?"),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                      ElevatedButton(
                        child: Text("Batal"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ));
      },
      child: BlocProvider<BuatkuisBloc>(
        create: (context) => kuisBloc,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Buat Kuis Baru"),
            centerTitle: true,
            actions: [
              (page == widget.jumlahSoal)
                  ? BlocListener<BuatkuisBloc, BuatkuisState>(
                      listener: (context, state) {
                        if (state is OnCreateKuisSucceded) {
                          showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                      title:
                                          Text("Tugas Berhasil Ditambahkan")))
                              .then((value) {
                            Navigator.pop(context);
                          });
                        }
                        if (state is OnCreateKuisError) {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text("Error Terdeteksi"),
                                    content: Text(state.errorMassage),
                                  ));
                        }
                      },
                      child: IconButton(
                        icon: Icon(Icons.send, color: Colors.white),
                        onPressed: () async {
                          keyForm.currentState.save();
                          if (keyForm.currentState.validate()) {
                            if (jawabanBenar == "") {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text("Jawaban Belum Dipilih"),
                                        content: Text("Mohon Pilih Jawaban"),
                                      ));
                            } else {
                              if (isiKuis.length >= page) {
                                isiKuis.removeAt(page - 1);

                                allJawaban = [];
                                for (var i = 0;
                                    i < widget.jumlahPilihanJawaban;
                                    i++) {
                                  allJawaban.add(ctr[i].text);
                                }
                                isiKuis.insert(page - 1, {
                                  "Soal": cSoal.text,
                                  "Pilihan Jawaban": allJawaban,
                                  "Jawaban Benar": jawabanBenar
                                });
                                print(isiKuis.toString());
                              }
                              if (isiKuis.length < page) {
                                allJawaban = [];
                                for (var i = 0;
                                    i < widget.jumlahPilihanJawaban;
                                    i++) {
                                  allJawaban.add(ctr[i].text);
                                }
                                isiKuis.add({
                                  "Soal": cSoal.text,
                                  "Pilihan Jawaban": allJawaban,
                                  "Jawaban Benar": jawabanBenar
                                });
                                print(isiKuis.toString());
                              }
                              jawabanBenar = "";
                              //Show Dialog Konfigurasi Kuis
                              List<Map<String, dynamic>> kelasYangTersedia =
                                  await FirestoreService().getAllKelasDiajar(
                                      widget.namaMataPelajaran,
                                      (widget.guru["Path"] as String)
                                          .split("/")
                                          .last,
                                      widget.guru["Nama Lengkap"]);
                              List<S2Choice<dynamic>> itemsKelas =
                                  List<S2Choice<Map<String, dynamic>>>.generate(
                                      kelasYangTersedia.length,
                                      (index) => S2Choice<Map<String, dynamic>>(
                                              title: kelasYangTersedia[index]
                                                  ["Data"]["Nama Kelas"],
                                              value: {
                                                "Nama Kelas":
                                                    kelasYangTersedia[index]
                                                        ["Data"]["Nama Kelas"],
                                                "Id": kelasYangTersedia[index]
                                                    ["Id"]
                                              }));
                              TextEditingController cJudulTugas =
                                  TextEditingController();
                              TextEditingController cWaktuKuis =
                                  TextEditingController();
                              List<Map<String, dynamic>> choicedItemsKelas = [];
                              showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text("Konfigurasi Kuis"),
                                              Divider(
                                                height: 10,
                                              ),
                                              TextFormField(
                                                controller: cJudulTugas,
                                                decoration: InputDecoration(
                                                  labelText: "Judul Tugas",
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                              SmartSelect<
                                                      Map<String,
                                                          dynamic>>.multiple(
                                                  title: "Pilih Kelas",
                                                  value: choicedItemsKelas,
                                                  choiceItems: itemsKelas,
                                                  onChange: (value) {
                                                    choicedItemsKelas =
                                                        value.value;
                                                  }),
                                              TextFormField(
                                                controller: cWaktuKuis,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                    labelText:
                                                        "Waktu Pengerjaan",
                                                    border:
                                                        OutlineInputBorder(),
                                                    suffixText: "Menit"),
                                              ),
                                              SizedBox(height: 10),
                                              ElevatedButton(
                                                child: Text("Buat"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  if (choicedItemsKelas
                                                          .length ==
                                                      0) {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                                title: Text(
                                                                    "Mohon Pilih Kelas Terlebih Dahulu")));
                                                  } else {
                                                    kuisBloc.add(CreateKuis(
                                                        cJudulTugas.text,
                                                        widget
                                                            .namaMataPelajaran,
                                                        {
                                                          "Nama Lengkap": widget
                                                                  .guru[
                                                              "Nama Lengkap"],
                                                          "Id": (widget.guru[
                                                                      "Path"]
                                                                  as String)
                                                              .split("/")
                                                              .last
                                                        },
                                                        choicedItemsKelas,
                                                        isiKuis,
                                                        cWaktuKuis.text));
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ));
                            }
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text("Form Tidak Lengkap"),
                                      content: Text(
                                          "Mohon Lengkapi Semua Form Yang Ada"),
                                    ));
                          }
                        },
                      ),
                    )
                  : SizedBox()
            ],
          ),
          body: Container(
            color: Colors.blue,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                                child: Text(
                              "Soal " +
                                  page.toString() +
                                  " Dari " +
                                  widget.jumlahSoal.toString(),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                                child: Container(
                              child: Container(
                                child: Form(
                                  key: keyForm,
                                  child: ListView(
                                    children: [
                                      TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value.length == 0) {
                                            return "Tidak Boleh Kosong";
                                          }
                                          return null;
                                        },
                                        controller: cSoal,
                                        maxLines: null,
                                        decoration: InputDecoration(
                                            hintText: "Isi Soal"),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      BlocConsumer<BuatkuisBloc, BuatkuisState>(
                                        listener: (context, state) {},
                                        builder: (context, state) =>
                                            ListView.builder(
                                          physics: ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              widget.jumlahPilihanJawaban,
                                          itemBuilder: (context, i) => Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: TextFormField(
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              validator: (value) {
                                                if (value.length == 0) {
                                                  return "Tidak Boleh Kosong";
                                                }
                                                return null;
                                              },
                                              controller: ctr[i],
                                              maxLines: null,
                                              decoration: InputDecoration(
                                                filled: (jawabanBenar == "")
                                                    ? false
                                                    : (jawabanBenar ==
                                                            ctr[i].text)
                                                        ? true
                                                        : false,
                                                fillColor: Colors.lightGreen,
                                                hintText: "Jawaban " +
                                                    pilihanJawaban[i],
                                                prefixText:
                                                    pilihanJawaban[i] + ". ",
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("Jawaban Yang Benar: "),
                                      Row(
                                        children: List<Widget>.generate(
                                            widget.jumlahPilihanJawaban,
                                            (index) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        if (ctr[index].text !=
                                                            "") {
                                                          jawabanBenar =
                                                              ctr[index].text;
                                                        }
                                                        kuisBloc.add(
                                                            ChoisedJawaban());
                                                      },
                                                      child: Text(
                                                          pilihanJawaban[
                                                              index])),
                                                )),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                (page != 1)
                                    ? ElevatedButton(
                                        onPressed: () {
                                          if (page != 1) {
                                            page--;
                                            setState(() {});
                                          }
                                        },
                                        child: Text("Kembali"))
                                    : SizedBox(),
                                (page != widget.jumlahSoal)
                                    ? ElevatedButton(
                                        onPressed: () {
                                          lanjut(keyForm);
                                        },
                                        child: Text("Lanjut"))
                                    : SizedBox(),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Wrap(
                      spacing: 5,
                      children: List<Widget>.generate(
                          widget.jumlahSoal,
                          (index) => ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.white)),
                                child: Text(
                                  (index + 1).toString(),
                                  style: TextStyle(color: Colors.lightBlue),
                                ),
                                onPressed: () {
                                  if (index + 1 > isiKuis.length) {
                                    page = isiKuis.length + 1;
                                  } else {
                                    page = index + 1;
                                  }
                                  setState(() {});
                                },
                              ))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void lanjut(GlobalKey<FormState> keyForm) {
    keyForm.currentState.save();
    if (keyForm.currentState.validate()) {
      if (jawabanBenar == "") {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Jawaban Belum Dipilih"),
                  content: Text("Mohon Pilih Jawaban"),
                ));
      } else {
        if (isiKuis.length >= page) {
          isiKuis.removeAt(page - 1);

          allJawaban = [];
          for (var i = 0; i < widget.jumlahPilihanJawaban; i++) {
            allJawaban.add(ctr[i].text);
          }
          isiKuis.insert(page - 1, {
            "Soal": cSoal.text,
            "Pilihan Jawaban": allJawaban,
            "Jawaban Benar": jawabanBenar
          });
          print(isiKuis.toString());
        }
        if (isiKuis.length < page) {
          allJawaban = [];
          for (var i = 0; i < widget.jumlahPilihanJawaban; i++) {
            allJawaban.add(ctr[i].text);
          }
          isiKuis.add({
            "Soal": cSoal.text,
            "Pilihan Jawaban": allJawaban,
            "Jawaban Benar": jawabanBenar
          });
          print(isiKuis.toString());
        }
        jawabanBenar = "";
        page++;
        setState(() {});
      }
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Form Tidak Lengkap"),
                content: Text("Mohon Lengkapi Semua Form Yang Ada"),
              ));
    }
  }
}
