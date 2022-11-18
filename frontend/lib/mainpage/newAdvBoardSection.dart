import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final contentType = ["anniversary", "todaysword", "doyouknow"];

final ann = [
  {"image": "image-path1", "content": "1111111111"},
  {"image": "image-path2", "content": "2222222222"},
  {"image": "image-path3", "content": "3333333333"}
];

final tdw = ["박꿀 수 없는 지하철 원격통신 박지원", "기엽지 못지지 지하철 기못지", "싸이버 지하철 채팅방 싸지방"];

final duk = [
  "싸트북은 감가율 제로의 기적의 전자제품입니다. 소중히 하십시오",
  "멀티캠퍼스 8층 어딘가에 수면실이 있다고 합니다.",
  "네이버 이메일이 바뀌었다고 합니다. 들어가보세요."
];

// 0123 랜덤 쓸거고

Random random = Random();

String type = contentType[random.nextInt(contentType.length)];

// switch(type){
//
// }

class newAdvBoardSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _newAdvBoardSectionState();
}

class _newAdvBoardSectionState extends State<newAdvBoardSection> {
  String _contentType = "";

  @override
  void initState() {
    setState(() {
      _contentType = contentType[random.nextInt(contentType.length)];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // anniversary
    Widget annWidget = Container();

    // todaysword
    Widget tdwWidget = Container();

    // doyouknow
    Widget dukWidget = Container();

    return Scaffold(
      body: Builder(builder: (context) {
        Widget result = Container();
        switch (_contentType) {
          case "anniversary":
            int k = random.nextInt(ann.length);
            String defaultImage = "defaultImagePath";
            result = Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  ann[k]['image'] ?? defaultImage,
                  width: 80.w,
                  height: 80.h,
                )
              ],
            );
            break;
          case "todaysword":
            int k = random.nextInt(tdw.length);
            result = Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [],
            );
            break;
          case "doyouknow":
            int k = random.nextInt(tdw.length);
            result = Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [],
            );
            break;
          default:
            result = Text("advBoardSection Loading Fail");
        }
        return result;
      }),
    );
  }
}
