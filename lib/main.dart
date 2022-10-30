import 'package:flutter/material.dart';
import 'bottom.dart';

/*
* 아직 연동되지 않은 위젯들(양도받기 위젯, 당첨 위젯, 탈락 위젯 등)을 모아놓았습니다.
* 추후 연동할 것입니다.
*/
import 'widgets_to_be_linked.dart';

// 메인 함수
void main() {
  runApp(
    const MaterialApp(
      // 디버그 표시를 없앤다.
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    )
  );
}

// 가장 큰 틀
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      // 디버그 표시를 없앤다.
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        // (임의로 만들어 놓은) 채팅창 윗부분
        appBar: AppBar(
          title: Center(
            child: Text('7323 열차')
          ),
          leading:(
            IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded),
                onPressed:(){
                  print('back_to_channel');
                }
              )
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add_alert_rounded),
              onPressed:(){
                print('add_alarm');
              }
            )
          ]
        ),
        // (임의로 만들어 놓은) 채팅창 내 채팅내역 부분
        /*
        * 임의로 버튼들 띄워놓았습니다. 시험용이며, 이들은 추후 각 기능에 맞게 배치 후 재 디자인 될 예정입니다.
        */
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.orangeAccent,
          child: Align(
            child: WidgetsToBeLinked(),
          )
        ),
        // 채팅창 아래 부분 -> bottom.dart에서 이어짐
        bottomNavigationBar: ChatWindowBottom(),
      )
    );
  }
}
