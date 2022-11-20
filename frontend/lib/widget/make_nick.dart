import 'package:flutter/material.dart';

///////// 유저 프로필사진만들기위한 것
Widget getAvatar(name) {
  String lastname =
      name[name.length - 3] + name[name.length - 2] + name[name.length - 1];
  String animal = lastname.trim();
  switch (animal) {
    case '사자':
      return Image.asset("assets/images/lion.png");
    case '코알라':
      return Image.asset("assets/images/koala.png");
    case '타조':
      return Image.asset("assets/images/ostrich.png");
    case '라쿤':
      return Image.asset("assets/images/raccoon.png");
    case '알파카':
      return Image.asset("assets/images/alpaca.png");
    case '호랑이':
      return Image.asset("assets/images/tiger.png");
    case '기린':
      return Image.asset("assets/images/giraffe.png");
    case '영양':
      return Image.asset("assets/images/antelope.png");
    case '원숭이':
      return Image.asset("assets/images/monkey.png");
    case '얼룩말':
      return Image.asset("assets/images/zebra.png");
    case '하마':
      return Image.asset("assets/images/hippo.png");
    case '캥거루':
      return Image.asset("assets/images/kangaroo.png");
    case '앵무새':
      return Image.asset("assets/images/macaw.png");
    case '고릴라':
      return Image.asset("assets/images/gorilla.png");
    case '펭귄':
      return Image.asset("assets/images/penguin.png");
    case '팬더':
      return Image.asset("assets/images/panda.png");
    case '코끼리':
      return Image.asset("assets/images/elephant.png");
    case '다람쥐':
      return Image.asset("assets/images/squirrel.png");
    case '독수리':
      return Image.asset("assets/images/eagle.png");
    default:
      return Image.asset("assets/images/bear.png");
  }
}
