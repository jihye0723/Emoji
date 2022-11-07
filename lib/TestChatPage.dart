import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestChatPage extends StatelessWidget {
  const TestChatPage(
      {Key? key,
      required this.userId,
      required this.userNick,
      required this.line,
      required this.trainNo,
      required this.stationName,
      required this.position})
      : super(key: key);

  final String userId;
  final String userNick;
  final String line;
  final int trainNo;
  final String stationName;
  final int position;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("userId : " + userId),
        Text("userNick : " + userNick),
        Text("line : " + line),
        Text("trainNo : " + trainNo.toString()),
        Text("stationName : " + stationName),
        // Text("direction : " +
        //     direction.toString() +
        //     ((direction % 2 == 1) ? " 홀수 외선 상행" : "짝수 내선 하행")),
        Text("position : " + position.toString()),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("뒤로가기"))
      ],
    );
    // throw UnimplementedError();
  }
}
