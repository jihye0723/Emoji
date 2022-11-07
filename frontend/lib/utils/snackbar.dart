import 'package:flutter/material.dart';

// 각 기능을 이용하고 난 뒤에 스낵바를 띄워 안내해주는 설정 더하였습니다. (추후 개선 및 디자인 가능)
void showSnackBar(BuildContext context, String snackBarText) {
  final snackBar = SnackBar(
    content: Text(snackBarText),
    backgroundColor: const Color(0xff32a1c8),
    behavior: SnackBarBehavior.floating,
    action: SnackBarAction(
      label: '확인',
      disabledTextColor: Colors.white,
      textColor: Colors.yellow,
      onPressed: () {
        //Do whatever you want
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
