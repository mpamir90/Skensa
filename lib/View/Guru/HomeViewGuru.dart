import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:skensa/View/Guru/GuruManagementView.dart';

import 'package:skensa/View/Guru/MataPelajaranGuru.dart';
import 'package:skensa/bloc/hydrateduser_bloc.dart';

class HomeViewGuru extends StatefulWidget {
  Map<String, dynamic> guru;
  HydrateduserBloc userBloc;
  HomeViewGuru(this.guru, this.userBloc);
  @override
  _HomeViewGuruState createState() => _HomeViewGuruState();
}

class _HomeViewGuruState extends State<HomeViewGuru> {
  int indexTabbar = 0;
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: indexTabbar,
          onTap: (value) {
            indexTabbar = value;
            pageController.jumpToPage(indexTabbar);
            setState(() {});
          },
          items: [
            BottomNavigationBarItem(
                label: "Tugas", icon: Icon(Icons.assignment)),
            BottomNavigationBarItem(
                label: "Tugas", icon: Icon(Icons.assignment)),
            BottomNavigationBarItem(label: "Akun", icon: Icon(Icons.person))
          ],
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: (value) {
            indexTabbar = value;
            pageController.jumpToPage(indexTabbar);
            setState(() {});
          },
          children: [
            Container(child: Center(child: Text(widget.guru.toString()))),
            MataPelajaranGuru(widget.guru),
            GuruManagementView(widget.guru, widget.userBloc)
          ],
        ));
  }
}
