import 'package:flutter/material.dart';
import 'FirstPage.dart';
import 'SecondPage.dart';

class Home extends StatefulWidget{
  const Home({Key? key}): super(key:key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{

  int _selectedIndex = 0;

  static List<Widget> pages = <Widget>[
    FirstPage(),
    SecondPage(),
  ];

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.train), label: "지하철"),
          const BottomNavigationBarItem(icon: Icon(Icons.image), label: "고독한"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}