import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:subway/SearchTrainDialog.dart';
import 'CustomSlider.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  // final searchTrainController = TextEditingController();

  final String _jsonString = "";
  final Map<String, dynamic> _jsonData = {};

  @override
  Widget build(BuildContext context) {
    // GPS 정보 받아와서 역 정보 구하면 역 이름 띄워줄 섹션 (사당)
    Widget stationNameSection = Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 30.h, bottom: 30.h),
      child: Container(
        width: 240.w,
        height: 60.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          color: Colors.white,
        ),
        child: Text(
          "사당",
          style: TextStyle(
            fontSize: 32.sp,
          ),
        ),
      ),
    );

    // 역 정보 받아와서 열차 운행정보 구하면 열차 도착정보 띄워줄 섹션 (2호선, { 낙성대, 2147, 3분 }, { 방배, 2156, 2분 })
    Widget stationInfoSection = Container(
      alignment: Alignment.topCenter,
      child: Container(
        width: 320.w,
        height: 120.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // border: Border.all(
          //   color: Colors.red,
          //   width: 1,
          // ),
          // border: Border(
          //     top: BorderSide(color: Colors.black, width: 1),
          //     bottom: BorderSide(color: Colors.black, width: 1)),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CustomSlider(
              trainNo: "2147",
              remainTime: 7777,
              direction: 1,
            ),
            Container(
              // currentStation
              child: Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0x7f32a23c)),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "사당",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 10.sp,
                      ),
                    ),
                  )),
            ),
            CustomSlider(
              trainNo: "2156",
              remainTime: 33,
              direction: 0,
            )
          ],
        ),
      ),
    );

    // 이미 타고 있어요 버튼
    Widget alreadyOnBoardSection = Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(
          top: 10.h,
          bottom: 10.h,
        ),
        child: SizedBox(
          width: 180.w,
          height: 40.h,
          child: OutlinedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext ctx) {
                    return SearchTrainDialog();
                  });
            },
            child: Text(
              "이미 타고있어요",
              style: TextStyle(fontSize: 20.sp),
            ),
          ),
        ));

    // 광고 섹션
    Widget advBoardSection = Container(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 320.w,
        height: 60.h,
        margin: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              'assets/images/train.png',
              width: 70.w,
              height: 70.h,
            ),
            Text(
              "광고문의 : A602팀a",
              style: TextStyle(
                fontSize: 20.sp,
              ),
            )
          ],
        ),
      ),
    );

    return Scaffold(
      body: Container(
        width: 1.sw,
        height: 1.sh,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            color: Color.fromARGB(1, 12, 12, 251)),
        alignment: Alignment.topCenter,
        child: Column(
          // <페이지 구조>
          // 현재 역 이름
          // 열차 도착정보 + 이미 (ListView)
          // 광고판
          children: <Widget>[
            stationNameSection,
            Expanded(
              child: ListView(
                // 동적 바인딩 하기 전에 테스트용 여러개 집어넣어봤음
                children: [
                  stationInfoSection,
                  stationInfoSection,
                  stationInfoSection,
                  // stationInfoSection,
                  // stationInfoSection,
                  alreadyOnBoardSection
                ],
              ),
            ),
            advBoardSection,
          ],
        ),
      ),
    );
  }
}
