// 라인별 색상 정의해서 사용할것
import 'dart:ui';
import 'package:flutter/material.dart';

lineColor(String? line) {
  Color _color = Colors.white60;

  switch (line) {
    case "1호선":
      _color = Color(0xff0D347F);
      break;
    case "2호선":
      _color = Color(0xff3B9F37);
      break;
    case "3호선":
      _color = Color(0xff3B9F37);
      break;
    case "4호선":
      _color = Color(0xff3165A8);
      break;
    case "5호선":
      _color = Color(0xff703E8C);
      break;
    case "6호선":
      _color = Color(0xff904D23);
      break;
    case "7호선":
      _color = Color(0xff5B692E);
      break;
    case "8호선":
      _color = Color(0xffC82363);
      break;
    case "9호선":
      _color = Color(0xffB39627);
      break;
    case "분당선":
      _color = Color(0xffDBA829);
      break;
    case "신분당선":
      _color = Color(0xff971F2D);
      break;
    case "경의중앙선":
      _color = Color(0xff76B69B);
      break;
    case "경춘선":
      _color = Color(0xff2D9B76);
      break;
    case "공항철도":
      _color = Color(0xff6CA8CE);
      break;
    default:
      break;
  }

  return _color;
}
