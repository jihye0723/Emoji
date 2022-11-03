import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:practice_01/kakao_login_button.dart';
import 'chat.dart';
import 'imagechat.dart';
import 'test.dart';

// 메인 함수
void main() {
  KakaoSdk.init(nativeAppKey: '9e8f2d7dc89324523cecae5569e5f764',);
  runApp(
    const MaterialApp(
      // 디버그 표시를 없앤다.
      debugShowCheckedModeBanner: false,
      home: MyApp(),
      title: "채팅",
    )
  );
}

// 가장 큰 틀
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        // (임의로 만들어 놓은) 채팅창 윗부분
        appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            title: const Text("Test"),

        ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text("문자채팅방"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TextChat(one: 1,name: "구라",))
                    );
                  },
                ),
                ElevatedButton(
                  child: const Text("사진채팅방"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // builder: (context) => TextChat(one: 1,name: "구라",)));
                    builder: (context) => const ImagePage(
                      title: "고독한 지하철",
                    )));
                  },
                ),
                KakaoLoginButton()
              ],
            )

          )
    );
  }
}
