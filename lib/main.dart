import 'package:flutter/material.dart';
import 'dart:convert';
import 'Home.dart';
import 'TrainInfo.dart';

void main() {

  // String jsonString1 = '''
  // {
  //   "currentStation" : "사당",
  //   "lineNo" : 2,
  //   "before" : {
  //     "stationName" : "낙성대",
  //     "trainCode" : "2147",
  //     "remainTime" : 3
  //   },
  //   "next" : {
  //     "stationName" : "방배",
  //     "trainCode" : "2156",
  //     "remainTime" : 2
  //   }
  // }
  // ''';
  //
  // Map<String, dynamic> jsonData = jsonDecode(jsonString1);
  //
  // TrainInfo trainInfo = TrainInfo.fromJson(jsonData);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '탭에 나오는 페이지 타이틀이구요',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '상단에 노출되는 홈페이지 타이틀입니다'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // TrainInfo trainInfo = TrainInfo.fromJson(jsonData);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}
