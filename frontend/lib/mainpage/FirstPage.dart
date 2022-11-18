import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:practice_01/mainpage/APIResponse.dart';
import 'package:practice_01/mainpage/JsonReform.dart';
import 'package:practice_01/mainpage/LineCodeToName.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'TrainArrival.dart';
import 'TrainInfo.dart';
import 'TrainLineColor.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  State<StatefulWidget> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  TrainInfo _trainInfo = TrainInfo(stationName: "", trainList: []);
  String _userId = "";
  bool _loadedLocation = false;
  bool _loadedInfo = false;
  Position? _currentPosition;
  int _itemCount = 0;
  String _stationName = "";

  final storage = FlutterSecureStorage();

  RefreshController _controller = RefreshController(initialRefresh: false);

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
  _onRefresh() async {
    print("refresh!!!!");
    await Future.delayed(const Duration(milliseconds: 100));
    // setState(() {
    //   _loadedInfo = false;
    // });
    // loadTrainInfo().then((value) => setState(() {
    //       _trainInfo = value;
    //       _itemCount = (value.trainList.length / 2).round();
    //       _loadedInfo = true;
    //     }));
    // // print("count : " + _itemCount.toString());
    setState(() {
      // _trainInfo = TrainInfo(stationName: "", trainList: []);
      _loadedInfo = false;
      _itemCount = 0;
    });
    await sendLocationToServer();
    print("onRefresh, stationName : " + _trainInfo.stationName);
    _controller.refreshCompleted();
  }

  // 위치 정보 서버로 전달 (Todo)
  sendLocationToServer() async {
    if (!_loadedLocation) {
      await getLocation().then((value) {
        setState(() {
          _currentPosition = value;
        });
      });
    }
    if (_currentPosition == null) {
      print("position is NULL in sendLocationToServer");
      setState(() {
        _loadedLocation = false;
      });
    } else {
      setState(() {
        _loadedLocation = true;
      });
      Uri uri = Uri.http("k7a6022.p.ssafy.io", "/subway/station", {
        // "latitude": position.latitude.toString(),
        // "longtitude": position.longitude.toString()
        "latitude": 37.500643.toString(), // 역삼역
        "longtitude": 127.036377.toString()
        // "latitude": 37.476559.toString(), // 사당역
        // "longtitude": 126.981633.toString()
      });

      // Future<String?> mytoken = storage.read(key: "accessToken");
      var mytoken = await storage.read(key: "accessToken");
      var myrefreshtoken = await storage.read(key: "refreshToken");

      print("accessToken : $mytoken");
      print("refreshToken : $myrefreshtoken");

      http.get(
        uri,
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $mytoken",
        },
      ).then((data) {
        if (data.statusCode == 200) {
          print("data : $data");
          print("data.body.length : ${data.body.length}");
          print("요청 uri : ${uri.toString()}");
          print("요청 결과 : ${data.body.toString()}");
          dynamic jsonParsed = jsonDecode(utf8.decode(data.bodyBytes));
          // for (dynamic item in jsonParsed) {
          //   print(item);
          // }
          List<APITrain> temp = [];
          for (dynamic item in jsonParsed) {
            print(item.runtimeType);
            temp.add(APITrain.fromJson(item));
          }
          TrainInfo ti = jsonReform(temp);
          // print("jsonParsed : $jsonParsed");

          setState(() {
            _loadedInfo = true;
            // _apiResponse = APIResponse(realtimeArrivalList: jsonParsed);
            _trainInfo = ti;
            _itemCount = (ti.trainList.length / 2).floor();

            // _apiResponse = jsonReform(jsonDecode(utf8.decode(data.bodyBytes)));
            print(
                "after setState DATA LENGTH : ${_trainInfo.trainList.length}");
            for (Train item in _trainInfo.trainList) {
              print(item.toString());
            }
          });
        } else if (data.statusCode == 401) {
          print(data.statusCode);
          print(data.body);
          print("요청 권한이 없습니다.");
        } else {
          print(data.statusCode);
          print(data.body);
          print("데이터를 불러오는데 실패했습니다.");
        }
      });
    }
  }

  @override
  void initState() {
    _controller = RefreshController(initialRefresh: true);
    setState(() {
      _userId = widget.userId;
    });
    getLocation().then((value) {
      print("init 에서 getLocation 한 결과확인 : $value");
      print("init 에서 sendLocationToServer 실행");
      setState(() {
        _currentPosition = value;
        _loadedLocation = true;
      });
      sendLocationToServer();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // GPS 정보 받아와서 역 정보 구하면 역 이름 띄워줄 섹션 (사당)
    Widget stationNameSection = Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 50.h, bottom: 30.h),
      child: Container(
        width: 240.w,
        height: 60.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            // color: Color(0xFFF8EFD
            width: 2,
          ),
          color: Color(0xFFfbfbfb),
          // color: Color(0xFFF8EFD2),
        ),
        child: _loadedInfo
            ? Text(_trainInfo.stationName, style: TextStyle(fontSize: 32.sp))
            : Text(""),
      ),
    );

    // 역 정보 받아와서 열차 운행정보 구하면 열차 도착정보 띄워줄 섹션 (2호선, { 낙성대, 2147, 3분 }, { 방배, 2156, 2분 })
    Widget stationInfoSection(int idx, TrainInfo ti) => Container(
          alignment: Alignment.topCenter,
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xFFfbfbfb),
                borderRadius: BorderRadius.circular(10.w)),
            width: 320.w,
            height: 120.h,
            alignment: Alignment.center,
            // decoration: BoxDecoration(
            //   color: Colors.white,
            // ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ti.trainList.isEmpty
                    ? Text("도착정보가 존재하지 않아요")
                    // : CustomSlider(
                    : TrainArrival(
                        userId: widget.userId,
                        stationName: ti.stationName,
                        train: ti.trainList[idx * 2],
                      ),
                Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ti.trainList.isEmpty
                            ? Colors.white60
                            : lineColor(ti.trainList[idx * 2].line)),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        // lineCodeName(_trainInfo.trainList[idx * 2].line),
                        ti.trainList[idx * 2].line + "\n" + ti.stationName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 10.sp,
                            color: Colors.white),
                      ),
                    )),
                ti.trainList.isEmpty
                    ? Text("도착정보가 존재하지 않아요")
                    // : CustomSlider(
                    : TrainArrival(
                        userId: widget.userId,
                        stationName: ti.stationName,
                        train: ti.trainList[(idx * 2) + 1],
                      )
              ],
            ),
          ),
        );

    // 광고 섹션
    Widget advBoardSection = Container(
      width: 320.w,
      height: 60.h,
      margin: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Color(0xfffbfbfb),
          // color: Color(0xFFF8EFD2),
          borderRadius: BorderRadius.circular(10.w)),
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
    );
    // );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xFFfbfbfb)),
        // decoration: BoxDecoration(color: Color(0xFFF8EFD2)),
        width: 1.sw,
        height: 1.sh,
        child: Column(
          // <페이지 구조>
          // 현재 역 이름
          // 열차 도착정보 (ListView) --> pull to Refresh 기능 추가
          // 광고판
          children: <Widget>[
            stationNameSection,
            Expanded(
              child: Scaffold(
                // backgroundColor: Color(0xFFF8EFD2),
                body: SmartRefresher(
                  enablePullDown: true,
                  controller: _controller,
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.all(8.w),
                      itemCount: _itemCount,
                      itemBuilder: (BuildContext context, int index) {
                        if (!_loadedInfo) {
                          return Text("Loading Fail");
                        } else if (_itemCount == 0) {
                          return Text("There is No Train");
                        } else {
                          return stationInfoSection(index, _trainInfo);
                        }
                      }),
                ),
              ),
            ),
            // advBoardSection,
          ],
        ),
      ),
    );
  }
}
