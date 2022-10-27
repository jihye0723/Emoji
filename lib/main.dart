import 'package:flutter/material.dart';

import 'chat.dart';

//메인 구동
void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
      title: "채팅",
      //theme: kDefaultTheme,
    ));

//가장 큰 틀
class MyApp extends StatelessWidget {
  final String name;
  var color;
  final String station;

  const MyApp({super.key, required this.name, this.color, this.station});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: const Text("Test"),
        ),
        body: Center(
          child: ElevatedButton(
            child: const Text("화면이동"),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TextChat(
                            name: "코딩하기 싫은 호랑이",
                            station: "역삼역",
                            color: colors.green,
                          )));
            },
          ),
        ));
  }
}
