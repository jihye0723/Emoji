import 'package:flutter/material.dart';
import 'chat.dart';
import 'imagechat.dart';
import 'test.dart';

//메인 구동
void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
      title: "채팅",
      //theme: kDefaultTheme,
    ));

//가장 큰 틀
class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
                      //builder: (context) => TextChat(one: 1,name: "구라",)));
                      builder: (context) => const ImagePage(
                            title: "고독한 지하철",
                          )));
            },
          ),
        ));
  }
}
