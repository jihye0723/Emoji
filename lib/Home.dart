import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'FirstPage.dart';
import 'SecondPage.dart';
import 'package:flutter/material.dart';
import 'CustomSlider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static List<Widget> pages = <Widget>[
    // 하단 내비게이션에 들어갈 페이지 리스트 2개
    FirstPage(),
    SecondPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("main test"),
      ),
      // 탭 누르는거에 따라서 페이지 전환
      body: pages[_selectedIndex],
      // body: CustomSlider(),
      // bottomNavigationBar: BottomNavigationBar(
      //   selectedItemColor: Colors.green,
      //   items: [
      //     const BottomNavigationBarItem(icon: Icon(Icons.train), label: "지하철"),
      //     const BottomNavigationBarItem(icon: Icon(Icons.image), label: "고독한"),
      //   ],
      //   currentIndex: _selectedIndex,
      //   onTap: _onItemTapped,
      // ),
    );
  }
}
