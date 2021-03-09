import 'package:flutter/material.dart';

class TugasView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pilih Mata Pelajaran"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          children: [
            Card(
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image(
                    image: AssetImage("assets/1.png"),
                  ),
                ),
                title: Text("Web Programing"),
                subtitle: Text("Tri Gunanto Hadi"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
