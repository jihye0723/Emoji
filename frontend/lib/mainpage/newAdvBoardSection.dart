import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final contentType = ["anniversary", "todaysword", "doyouknow"];

final ann = [
  {"image": "assets/images/do.png", "content": "dodo"},
  {"image": "assets/images/park.png", "content": "parkpark"},
  {"image": "assets/images/jeong.png", "content": "jeongjeong"},
  {"image": "assets/images/jo.png", "content": "jojo"},
  {"image": "assets/images/choi.png", "content": "choichoi"},
  {"image": "assets/images/han.jpg", "content": "hanhan"},
];

final tdw = [
  "박꿀 수 없는 지하철 원격통신 박지원",
  "기엽지 못지지 지하철 기못지",
  "싸이버 지하철 채팅방 싸지방",
  "멀티캠퍼스 정말 좋아요 최고 삼성 최고",
  "콜라는 펩시지 반박시 지상렬",
  "어? 금지"
];

final duk = [
  "이 어플 이름은 기못지가 될 뻔 했습니다!",
  "싸트북은 감가율 제로의 기적의 노트북입니다!",
  "멀티캠퍼스 8층 어딘가에 수면실이 있다고 합니다.",
  "갓찬국 그는 신이야!!!",
  "독도에는 바나프레소가 있습니다!",
  "욱진돗개스터디윗미"
];

// 0123 랜덤 쓸거고

Random random = Random();

String type = contentType[random.nextInt(contentType.length)];

// switch(type){
//
// }

class newAdvBoardSection extends StatefulWidget {
  const newAdvBoardSection({Key? key, required this.contentNo})
      : super(key: key);

  final int contentNo;
  @override
  State<StatefulWidget> createState() => _newAdvBoardSectionState();
}

class _newAdvBoardSectionState extends State<newAdvBoardSection> {
  String _contentType = "";

  @override
  void initState() {
    setState(() {
      _contentType = contentType[widget.contentNo];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        Widget result = Container();
        switch (_contentType) {
          case "anniversary":
            int k = random.nextInt(ann.length);
            result =
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(4.0, 4.0),
                        blurRadius: 10.0,
                        spreadRadius: 1.0,
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(-4.0, -4.0),
                        blurRadius: 10.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          alignment: Alignment.center,
                          ann[k]['image']!,
                          height: 80.h,
                        ),
                        Padding(padding: EdgeInsets.only(left: 30.w,right: 30.w)),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            ann[k]['content']!,
                            style: TextStyle(fontSize: 20.sp,fontFamily: "cafe24_surround"),
                          ),
                        )
                      ],
                    ),
                );
            break;
          case "todaysword":
            int k = random.nextInt(tdw.length);
            result =
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(4.0, 4.0),
                        blurRadius: 10.0,
                        spreadRadius: 1.0,
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(-4.0, -4.0),
                        blurRadius: 10.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 15.w, top: 10.h),
                          child: Text("오늘의 한마디", style: TextStyle(fontSize: 19.sp,fontFamily: "cafe24_surround"))),
                      Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 10.h,left: 15.w,right: 15.w),
                          child: Text(tdw[k], style: TextStyle(fontSize: 15.sp,fontFamily: "cafe24_surround"))),
                    ],
                  ),
                );
            break;
          case "doyouknow":
            int k = random.nextInt(duk.length);
            result = Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(4.0, 4.0),
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                  ),
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-4.0, -4.0),
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 15.w, top: 10.h),
                    child: Text("알고 계셨나요?", style: TextStyle(fontSize: 19.sp,fontFamily: "cafe24_surround"))),
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 10.h,left: 15.w,right: 15.w),
                      child: Text(duk[k], style: TextStyle(fontSize: 15.sp,fontFamily: "cafe24_surround"))),
                ],
              ),
            );
            break;
          default:
            print("Failed to load newAdvBoardSection");
            result = Text("Failed to load newAdvBoardSection");
        }
        return result;
      }),
    );
  }
}
