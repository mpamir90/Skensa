import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:skensa/Hive%20Databases/Models/KelasModel.dart';
import 'package:skensa/bloc/tugassiswa_bloc.dart';

class TugasView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pilih Mata Pelajaran"),
        actions: [
          BlocBuilder<TugassiswaBloc, TugassiswaView>(
            child: IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {},
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: Hive.openBox<KelasModel>("Kelas"),
          builder: (context, AsyncSnapshot<Box<KelasModel>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text("Loading...");
                break;
              case ConnectionState.waiting:
                return Text("Loading...");
                break;
              case ConnectionState.active:
                return Text("Loading...");
                break;
              case ConnectionState.done:
                return StreamBuilder(
                    stream: snapshot.data.watch(),
                    builder: (context, AsyncSnapshot<BoxEvent> snapshotEvent) =>
                        (snapshot.data.length == 0)
                            ? Center(child: Text("No Data"))
                            : ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, i) => Text("yoi")));
                break;
            }
          }),
    );
  }
}
