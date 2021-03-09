import 'package:flutter/material.dart';
import 'package:collection/collection.dart' as colection;
import 'package:skensa/View/Guru/TugasGuruView.dart';

class MataPelajaranGuru extends StatelessWidget {
  Map<String, dynamic> guru;
  MataPelajaranGuru(this.guru);
  List<Widget> listMataPelajaranWidget = [];

  @override
  Widget build(BuildContext context) {
    var newFilter = colection.groupBy(
        guru["Mengajar"], (obj) => obj["Nama Mata Pelajaran"]);
    print(newFilter.toString());
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            onTap: () {}, child: Text("Pilih Mata Pelajaran Anda")),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
        centerTitle: true,
      ),
      body: Container(
          child: ListView.builder(
        itemCount: (guru["Mengajar"] as List).length,
        itemBuilder: (context, i) => GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TugasGuruView(
                        guru["Mengajar"][i]["Nama Mata Pelajaran"], guru)));
          },
          child: Card(
            child: ListTile(
              title: Text(guru["Mengajar"][i]["Nama Mata Pelajaran"]),
              subtitle:
                  Text("Kelas: " + guru["Mengajar"][i]["Kelas"]["Nama Kelas"]),
              leading: Icon(
                Icons.library_books,
                size: 40,
              ),
            ),
          ),
        ),
      )),
    );
  }
}
