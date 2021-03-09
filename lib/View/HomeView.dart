import 'package:flutter/material.dart';
import 'package:skensa/View/TugasView.dart';

class HomeView extends StatefulWidget {
  Map<String, dynamic> siswa;
  HomeView(this.siswa);
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
                label: "Kelas", icon: Icon(Icons.assignment)),
            BottomNavigationBarItem(
                label: "Tugas", icon: Icon(Icons.assignment))
          ],
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: (page) {
            indexTabbar = page;
            pageController.jumpToPage(indexTabbar);
            setState(() {});
          },
          children: [Center(child: Text(widget.siswa.toString())), TugasView()],
        ));
  }
}
