import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestChatPage extends StatelessWidget {
  const TestChatPage(
      {Key? key,
      required this.userId,
      required this.userNick,
      required this.rail,
      required this.trainNo,
      required this.position})
      : super(key: key);

  final String userId;
  final String userNick;
  final String rail;
  final int trainNo;
  final int position;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("userId : " + userId),
        Text("userNick : " + userNick),
        Text("rail : " + rail),
        Text("trainNo : " + trainNo.toString()),
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
