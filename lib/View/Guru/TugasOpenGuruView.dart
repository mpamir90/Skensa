import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skensa/Hive%20Databases/Models/SoalModel.dart';
import 'package:skensa/Services/FireStoreService.dart';
import 'package:skensa/bloc/buatkuis_bloc.dart';
import 'package:smart_select/smart_select.dart';

class TugasOpenGuruView extends StatefulWidget {
  SoalModel soal;
  Map<String, dynamic> guru;
  TugasOpenGuruView(this.soal, this.guru);

  @override
  _TugasOpenGuruViewState createState() => _TugasOpenGuruViewState();
}

class _TugasOpenGuruViewState extends State<TugasOpenGuruView> {
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

  BuatkuisBloc kuisBloc = BuatkuisBloc();

  @override
  Widget build(BuildContext context) {
    String jawabanBenar = widget.soal.soal[page - 1]["Jawaban Benar"];
    GlobalKey<FormState> keyForm = GlobalKey();
    TextEditingController cSoal =
        TextEditingController(text: widget.soal.soal[page - 1]["Soal"]);
    List<TextEditingController> ctr = List<TextEditingController>.generate(
        (widget.soal.soal[0]["Pilihan Jawaban"] as List).length,
        (index) => TextEditingController(
            text: widget.soal.soal[page - 1]["Pilihan Jawaban"][index]));
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
            title: Text("Quiz: " + widget.soal.namaTugas),
            centerTitle: true,
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
                                  widget.soal.soal.length.toString(),
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
                                        enabled: false,
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
                                          itemCount: ctr.length,
                                          itemBuilder: (context, i) => Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: TextFormField(
                                              enabled: false,
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
                                (page != widget.soal.soal.length)
                                    ? ElevatedButton(
                                        onPressed: () {
                                          page += 1;
                                          setState(() {});
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
                          widget.soal.soal.length,
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
                                  page = index + 1;
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
}
