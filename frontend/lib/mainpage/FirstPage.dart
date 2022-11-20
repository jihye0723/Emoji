import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:practice_01/mainpage/APIResponse.dart';
import 'package:practice_01/mainpage/GetOnTrainDialog.dart';
import 'package:practice_01/mainpage/JsonReform.dart';
import 'package:practice_01/mainpage/LineCodeToName.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'TrainArrival.dart';
import 'TrainInfo.dart';
import 'TrainLineColor.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'newAdvBoardSection.dart';
import 'dart:math';
import '../data/stationLine.dart';

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
  int _contentNo = -1;

  Random random = Random();

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
      _contentNo = -1;
      print("contentNo : $_contentNo");
    });
    await sendLocationToServer();
    print("onRefresh, stationName : " + _trainInfo.stationName);
    setState(() {
      _contentNo = random.nextInt(3);
      print("changed contentNo : $_contentNo");
    });
    print("onrefresh accessToken : ${await storage.read(key: 'accessToken')}");
    print(
        "onrefresh refreshToken : ${await storage.read(key: 'refreshToken')}");
    print("userId : $_userId");
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
         "latitude": position.latitude.toString(),
         "longtitude": position.longitude.toString()
        //"latitude": 37.500643.toString(), // 역삼역
        //"longtitude": 127.036377.toString()
        //"latitude": 37.476559.toString(), // 사당역
        //"longtitude": 126.981633.toString()
      });

      // Future<String?> mytoken = storage.read(key: "accessToken");
      var mytoken = await storage.read(key: "accessToken");
      var myrefreshtoken = await storage.read(key: "refreshToken");

      print("accessToken : $mytoken");
      print("refreshToken : $myrefreshtoken");

      Map<String, dynamic> payload = Jwt.parseJwt(mytoken!);
      print("payload : ");
      print(payload);

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
            // _itemCount = (ti.trainList.length / 2).floor();
            // stationLine 사용할 경우
            _itemCount = stationLine[ti.stationName]!.length;

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
      _contentNo = random.nextInt(3);
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
          color: Color(0xFFF8EFD2),
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
        child: _loadedInfo
            ? Text(_trainInfo.stationName,
                style:
                    TextStyle(fontSize: 30.sp, fontFamily: "cafe24_surround"))
            : Text(""),
      ),
    );

    // stationLine 사용하기 전 코드
    // 역 정보 받아와서 열차 운행정보 구하면 열차 도착정보 띄워줄 섹션 (2호선, { 낙성대, 2147, 3분 }, { 방배, 2156, 2분 })
    // Widget stationInfoSection(int idx, TrainInfo ti) => Container(
    //       alignment: Alignment.topCenter,
    //       child: Container(
    //         decoration: BoxDecoration(
    //             color: Color(0xFFfbfbfb),
    //             borderRadius: BorderRadius.circular(10.w)),
    //         width: 320.w,
    //         height: 120.h,
    //         alignment: Alignment.center,
    //         // decoration: BoxDecoration(
    //         //   color: Colors.white,
    //         // ),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: <Widget>[
    //             ti.trainList.isEmpty
    //                 ? Text("도착정보가 존재하지 않아요")
    //                 // : CustomSlider(
    //                 : TrainArrival(
    //                     userId: widget.userId,
    //                     stationName: ti.stationName,
    //                     train: ti.trainList[idx * 2],
    //                   ),
    //             Container(
    //                 width: 50.w,
    //                 height: 50.h,
    //                 decoration: BoxDecoration(
    //                     shape: BoxShape.circle,
    //                     color: ti.trainList.isEmpty
    //                         ? Colors.white60
    //                         // : lineColor(ti.trainList[idx * 2].line)),
    //                         // stationLine 사용할 경우
    //                         : lineColor(stationLine[ti.stationName]![idx])),
    //                 child: Container(
    //                   alignment: Alignment.center,
    //                   child: Text(
    //                     ti.trainList[idx * 2].line + "\n" + ti.stationName,
    //                     textAlign: TextAlign.center,
    //                     style: TextStyle(
    //                         fontWeight: FontWeight.w700,
    //                         fontSize: 10.sp,
    //                         color: Colors.white),
    //                   ),
    //                 )),
    //             ti.trainList.isEmpty
    //                 ? Text("도착정보가 존재하지 않아요")
    //                 // : CustomSlider(
    //                 : TrainArrival(
    //                     userId: widget.userId,
    //                     stationName: ti.stationName,
    //                     train: ti.trainList[(idx * 2) + 1],
    //                   )
    //           ],
    //         ),
    //       ),
    //     );

    // stationLine 사용할 경우
    newStationInfoSection(String stationName, int idx, TrainInfo ti) {
      String imageEmpty = "assets/images/sub_empty.png";
      String imageRight = "assets/images/sub_empty.png";
      String imageLeft = "assets/images/sub_empty.png";

      // 왼쪽 (direction 1)
      Widget innerLeft = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100.w,
            height: 30.h,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(imageEmpty), fit: BoxFit.fill)),
          ),
          Container(
            width: 110.w,
            height: 20.h,
            alignment: Alignment.center,
            child: Text(
              "도착정보가 없어요",
            ),
          ),
        ],
      );

      // 가운데 (호선, 역이름)
      Widget innerCenter = Container(
          width: 50.w,
          height: 50.h,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: lineColor(stationLine[ti.stationName]![idx])),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              "${stationLine[ti.stationName]![idx]}\n${ti.stationName}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 10.sp,
                  color: Colors.white),
            ),
          ));

      // 오른쪽 (direction 0)
      Widget innerRight = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100.w,
            height: 30.h,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(imageEmpty), fit: BoxFit.fill)),
          ),
          Container(
            width: 110.w,
            height: 20.h,
            alignment: Alignment.center,
            child: Text(
              "도착정보가 없어요",
            ),
          ),
        ],
      );

      int flag = 0;
      int startIdx = -1;
      for (int i = 0; i < ti.trainList.length; i++) {
        var t = ti.trainList[i];
        if (t.line == stationLine[stationName]![idx]) {
          if (startIdx == -1) startIdx = i;
          if (t.direction == 1) {
            flag += 1;
          } else if (t.direction == 0) {
            flag += 2;
          }
        }
      }

      // 도착 플래그에 따라 innerChildren 수정
      switch (flag) {
        case 1:
          int remainTime = (ti.trainList[startIdx].remainTime / 60).floor();
          String arrivalInfo = remainTime > 0 ? "약 $remainTime분 후 도착" : "곧 도착";

          if (remainTime < 2) {
            imageRight = "assets/images/sub_right_01.png";
          } else if (remainTime < 5) {
            imageRight = "assets/images/sub_right_02.png";
          } else if (remainTime < 10) {
            imageRight = "assets/images/sub_right_03.png";
          } else {
            imageRight = "assets/images/sub_empty.png";
          }

          innerLeft = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext ctx) {
                        return GetOnTrainDialog(
                            userId: widget.userId,
                            train: ti.trainList[startIdx],
                            // trainNo: int.parse(widget.train.trainNo),
                            // line: widget.train.line!,
                            stationName: stationName);
                        // remainTime: widget.train.remainTime);
                      })
                },
                child: Container(
                  width: 100.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(imageRight), fit: BoxFit.fill)),
                ),
              ),
              Container(
                width: 110.w,
                height: 20.h,
                alignment: Alignment.center,
                child: Text(
                  arrivalInfo,
                ),
              ),
            ],
          );
          break;
        case 2:
          int remainTime = (ti.trainList[startIdx].remainTime / 60).floor();
          String arrivalInfo = remainTime > 0 ? "약 $remainTime분 후 도착" : "곧 도착";

          if (remainTime < 2) {
            imageLeft = "assets/images/sub_left_01.png";
          } else if (remainTime < 5) {
            imageLeft = "assets/images/sub_left_02.png";
          } else if (remainTime < 10) {
            imageLeft = "assets/images/sub_left_03.png";
          } else {
            imageLeft = "assets/images/sub_empty.png";
          }

          innerRight = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext ctx) {
                        return GetOnTrainDialog(
                            userId: widget.userId,
                            train: ti.trainList[startIdx],
                            // trainNo: int.parse(widget.train.trainNo),
                            // line: widget.train.line!,
                            stationName: stationName);
                        // remainTime: widget.train.remainTime);
                      })
                },
                child: Container(
                  width: 100.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(imageLeft), fit: BoxFit.fill)),
                ),
              ),
              Container(
                width: 110.w,
                height: 20.h,
                alignment: Alignment.center,
                child: Text(
                  arrivalInfo,
                ),
              ),
            ],
          );
          break;
        case 3:
          int remainTime = (ti.trainList[startIdx].remainTime / 60).floor();
          String arrivalInfo = remainTime > 0 ? "약 $remainTime분 후 도착" : "곧 도착";

          if (remainTime < 2) {
            imageRight = "assets/images/sub_right_01.png";
          } else if (remainTime < 5) {
            imageRight = "assets/images/sub_right_02.png";
          } else if (remainTime < 10) {
            imageRight = "assets/images/sub_right_03.png";
          } else {
            imageRight = "assets/images/sub_empty.png";
          }

          innerLeft = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext ctx) {
                        return GetOnTrainDialog(
                            userId: widget.userId,
                            train: ti.trainList[startIdx],
                            // trainNo: int.parse(widget.train.trainNo),
                            // line: widget.train.line!,
                            stationName: stationName);
                        // remainTime: widget.train.remainTime);
                      })
                },
                child: Container(
                  width: 100.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(imageRight), fit: BoxFit.fill)),
                ),
              ),
              Container(
                width: 110.w,
                height: 20.h,
                alignment: Alignment.center,
                child: Text(
                  arrivalInfo,
                ),
              ),
            ],
          );

          remainTime = (ti.trainList[startIdx + 1].remainTime / 60).floor();
          arrivalInfo = remainTime > 0 ? "약 $remainTime분 후 도착" : "곧 도착";

          if (remainTime < 2) {
            imageLeft = "assets/images/sub_left_01.png";
          } else if (remainTime < 5) {
            imageLeft = "assets/images/sub_left_02.png";
          } else if (remainTime < 10) {
            imageLeft = "assets/images/sub_left_03.png";
          } else {
            imageLeft = "assets/images/sub_empty.png";
          }

          innerRight = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext ctx) {
                        return GetOnTrainDialog(
                            userId: widget.userId,
                            train: ti.trainList[startIdx + 1],
                            // trainNo: int.parse(widget.train.trainNo),
                            // line: widget.train.line!,
                            stationName: stationName);
                        // remainTime: widget.train.remainTime);
                      })
                },
                child: Container(
                  width: 100.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(imageLeft), fit: BoxFit.fill)),
                ),
              ),
              Container(
                width: 110.w,
                height: 20.h,
                alignment: Alignment.center,
                child: Text(
                  arrivalInfo,
                ),
              ),
            ],
          );
          break;
      }

      // 최종적으로 리턴할 위젯
      return Container(
        alignment: Alignment.topCenter,
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xFFfbfbfb),
              borderRadius: BorderRadius.circular(10.w)),
          width: 320.w,
          height: 120.h,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [innerLeft, innerCenter, innerRight],
          ),
        ),
      );
    }

    // 광고 섹션
    // Widget advBoardSection = Container(
    //   width: 320.w,
    //   height: 60.h,
    //   margin: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
    //   alignment: Alignment.center,
    //   decoration: BoxDecoration(
    //       color: Color(0xfffbfbfb),
    //       // color: Color(0xFFF8EFD2),
    //       borderRadius: BorderRadius.circular(10.w)),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
    //     children: [
    //       Image.asset(
    //         'assets/images/train.png',
    //         width: 70.w,
    //         height: 70.h,
    //       ),
    //       Text(
    //         "광고문의 : A602팀a",
    //         style: TextStyle(
    //           fontSize: 20.sp,
    //         ),
    //       )
    //     ],
    //   ),
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
                          // return stationInfoSection(index, _trainInfo);
                          // stationLine 사용할 경우
                          return newStationInfoSection(
                              _trainInfo.stationName, index, _trainInfo);
                        }
                      }),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Pull to Refresh",
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                    Icon(Icons.arrow_downward, size: 14.sp),
                  ],
                ),
                // Text(
                //   "Last Updated : (${_updatedTime ?? 'updated time'})",
                //   style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                // )
              ],
            ),
            Container(
                width: 320.w,
                height: 100.h,
                margin: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  // color: Color(0xfffbfbfb),
                  // border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(10),
                  // color: Color(0xFFF8EFD2)
                ),
                child: _contentNo == -1
                    // ? advBoardSection
                    ? Container()
                    : newAdvBoardSection(contentNo: _contentNo)),
          ],
        ),
      ),
    );
  }
}
