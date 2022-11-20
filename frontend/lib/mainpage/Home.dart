import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'FirstPage.dart';
import 'SecondPage.dart';
import 'package:flutter/material.dart';
// import 'package:faker/faker.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  // var faker = Faker();
  String _token = "";

  late List<Widget> pages = [];
  static final storage = FlutterSecureStorage();

  // static List<Widget> pages = <Widget>[
  //   // 하단 내비게이션에 들어갈 페이지 리스트 2개
  //   FirstPage(userId: _email),
  //   // SecondPage(),
  // ];

  @override
  void initState() {
    // print("pages");
    storage.read(key: 'accessToken').then((value) {
      if (value != null) {
        setState(() {
          _token = value;
          Map<String, dynamic> payload = Jwt.parseJwt(_token);
          String email = payload['sub'];
          pages = <Widget>[
            // 하단 내비게이션에 들어갈 페이지 리스트 2개
            // FirstPage(userId: "gkswotmd96@naver.com"),
            FirstPage(userId: email),
            // SecondPage(),
          ];
        });
      }
    });
    // print(_email);
    super.initState();
  }

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 탭 누르는거에 따라서 페이지 전환
      appBar: AppBar(
        title: Text("이름 모를 지하철",
            style:
                TextStyle(color: Colors.black, fontFamily: "cafe24_surround")),
        backgroundColor: Color(0xFFF8EFD2),
        centerTitle: true,
      ),
      body: pages.length > 0 ? pages[_selectedIndex] : Container(),
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
