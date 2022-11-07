import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:subway/SearchTrainDialog.dart';
import 'CustomSlider.dart';
import 'SearchTrainDialog.dart';
import 'TrainInfo.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  TrainInfo _trainInfo = TrainInfo(stationName: "stationName", trainList: []);
  bool _loadedInfo = false;
  Position? _currentPosition;
  bool _checkedPosition = false;
  // String _stationName = "무슨무슨역";

  // [TEST] sample.json 읽어서 json parsing (Done)
  Future<TrainInfo> loadTrainInfo() async {
    String jsonString = await rootBundle.loadString('assets/data/sample.json');
    final jsonResponse = json.decode(jsonString);
    return TrainInfo.fromJson(jsonResponse);
  }

  // 현재 위치 조회 (Done)
  Future<Position> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  // 페이지 리로드  (Todo)
  void reloadPage() {}

  // 위치 정보 서버로 전달 (Todo)
  void sendLocationToServer(Position position) {}

  // 서버로부터 받은 역 정보 읽어서 parsing (Todo)
  void getTrainInfo() {}

  // 탑승정보 서버로 전달 (Todo)
  void sendBoardingInfoToServer() {}

  @override
  void initState() {
    getLocation().then((value) => setState(() {
          _currentPosition = value;
          _checkedPosition = true;
        }));
    loadTrainInfo().then((value) => setState(() {
          // print(value.stationName + " " + value.trainList.length.toString());
          _trainInfo = value;
          _loadedInfo = true;
        }));
    super.initState();
  }

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
        child: _loadedInfo
            ? Text(_trainInfo.stationName, style: TextStyle(fontSize: 32.sp))
            : Text("로딩중", style: TextStyle(fontSize: 32.sp, color: Colors.red)),
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
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.all(8.w),
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return stationInfoSection;
                    })),
            alreadyOnBoardSection,
            // child: ListView(
            //   // 동적 바인딩 하기 전에 테스트용 여러개 집어넣어봤음
            //   children: [stationInfoSection, alreadyOnBoardSection],
            // ),
            advBoardSection,
          ],
        ),
      ),
    );
  }
}
