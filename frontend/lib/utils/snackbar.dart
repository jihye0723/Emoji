import 'package:flutter/material.dart';

// 각 기능을 이용하고 난 뒤에 스낵바를 띄워 안내해주는 설정 더하였습니다. (추후 개선 및 디자인 가능)
void showSnackBar(
    BuildContext context, String snackBarText, String snackBarType) {
  // snackBarType 이 "common"인 경우, 아래의 색상 적용됨.
  int bgColorValue = 0xff32A1C8; // 파란색
  int disabledTextColorValue = 0xffFFFFFF; // 하얀색
  int textColorValue = 0xffffffff; // 노란색

  // snackBarType 이 "villain"인 경우, 아래의 색상 적용됨.
  if (snackBarType == "villain") {
    bgColorValue = 0xffF49D1A; // 주황색
    disabledTextColorValue = 0xffFFFFFF; // 하얀색
    textColorValue = 0xffFFFFFF; // 검회색0xff393E46
  }

  final snackBar = SnackBar(
    content: Text(snackBarText),
    backgroundColor: Color(bgColorValue),
    behavior: SnackBarBehavior.floating,
    action: SnackBarAction(
      label: '확인',
      disabledTextColor: Color(disabledTextColorValue),
      textColor: Color(textColorValue),
      onPressed: () {
        //Do whatever you want
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
