import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

import '/utils/snackbar.dart' as snackbar;
import '../data/station.dart' as stationdata;
import '../widget/chat_screen.dart';

// 채팅방있는 페이지
class TextChat extends StatefulWidget {
  //노선,열차,현재역
  final String trainNo;
  final String position;
  final String stationName;
  final String line;
  final String myuserId;
  final String mynickName;

  TextChat(
      {super.key,
      required this.trainNo,
      required this.position,
      required this.stationName,
      required this.line,
      required this.myuserId,
      required this.mynickName});

  //현재역 찾기
  late String _info = "";
  late String _destination = "";

  @override
  State<TextChat> createState() => _TextChatState();
}

////// 채팅
class _TextChatState extends State<TextChat> {
  //목적지 도착 textfield 컨트롤러
  final _destinationEditController = TextEditingController();

  // 채팅방 색상
  var _color;

  //목적지 설정을 위한 데이터
  late List<String> rain;
  late int direction;
  Timer? _timer;
  late int point = 0;

  String roomname = "";

  AudioPlayer _audioPlayer = AudioPlayer();

  //시작..
  @override
  void initState() {
    super.initState();
    widget._info = widget.stationName;
    print(widget.myuserId);
    find();
    makeroom();
    directionM();
    //시간마다 정보변경
    setState(() {
      _timer = Timer.periodic(Duration(seconds: 90), (timer) {
        test();
        print(widget._info);
        if (widget._info == widget._destination) {
          snackbar.showSnackBar(context, '곧 목적지에 도착합니다!', 'common');
          _timer?.cancel();
        }
      });
    });
  }

  void makeroom() {
    roomname = "${widget.trainNo}-${widget.position}";
  }

  // 지하철 지나가는 거 표현
  void test() {
    if (direction == 0) {
      if (point + 1 >= rain.length) {
        setState(() {
          widget._info = rain[0];
        });
        point = 0;
      } else {
        setState(() {
          widget._info = rain[point + 1];
        });
        point++;
      }
    } else {
      if (point - 1 < 0) {
        setState(() {
          widget._info = rain[rain.length - 1];
        });
        point = rain.length - 1;
      } else {
        setState(() {
          widget._info = rain[point - 1];
        });
        point--;
      }
    }
  }

  @override
  void dispose() {
    _destinationEditController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: _color,
        appBar: AppBar(
          //뒤로가기
          leading: IconButton(
              onPressed: () {
                // Navigator.pop(context);
                Navigator.pop(context, 'refresh');
              },
              icon: const Icon(Icons.arrow_back_ios),
              padding: EdgeInsets.only(left: 10.w)),
          centerTitle: true,
          elevation: 0,
          title: Stack(
            children: [
              Container(
                width: (width * 0.35).w,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                //전광판
                child:
                    MyStatefulWidget(text: widget._info, color: Colors.white),
                //child: Text(widget._info),
              ),
              Positioned(
                top: 100.h,
                child: SizedBox(
                  width: 350.w,
                  height: 100.h,
                ),
              ),
            ],
          ),
          backgroundColor: _color,
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext ctx) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          content: StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(padding: EdgeInsets.only(top: 20.h)),
                                  Text(
                                    "내리시는 데 도움이 필요하신가요?",
                                    style: TextStyle(
                                        fontFamily: "cafe24_surround"),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 10.h)),
                                  Text("(소리주의)",
                                      style: TextStyle(
                                          fontFamily: "cafe24_surround")),
                                ],
                              );
                            },
                          ),
                          actionsPadding: EdgeInsets.only(bottom: 30.h),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white, // 텍스트 색 바꾸기
                                backgroundColor: _color, // 백그라운드로 컬러 설정

                                textStyle: TextStyle(fontSize: 16.sp),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: () async {
                                await _audioPlayer
                                    .setAsset("assets/audio/helpme.mp3");
                                _audioPlayer.play();
                              },
                              child: const Text("네",
                                  style:
                                      TextStyle(fontFamily: "cafe24_surround")),
                            )
                          ],
                          title: Column(
                            children: [
                              Text("도움!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: "cafe24_surround",
                                      fontSize: 30.sp)),
                            ],
                          ),
                        );
                      });
                },
                icon: const Icon(Icons.emoji_people)),
            IconButton(
              onPressed: () {
                //경로선택 dialog
                showDialog(
                    context: context,
                    builder: (BuildContext ctx) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        content: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TypeAheadField(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          controller:
                                              _destinationEditController,
                                          //autofocus: true,
                                          style: DefaultTextStyle.of(context)
                                              .style
                                              .copyWith(
                                                  height: 1,
                                                  fontSize: 17.sp,
                                                  color: Colors.black),
                                          decoration: InputDecoration(
                                            hintText:
                                                _destinationEditController.text,
                                            border: OutlineInputBorder(),
                                            contentPadding: EdgeInsets.all(1),
                                            constraints:
                                                BoxConstraints(maxWidth: 180.w),
                                          )),
                                  suggestionsCallback: (pattern) {
                                    return getSuggestions(pattern);
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      leading: Icon(Icons.location_on),
                                      title: Text(suggestion),
                                    );
                                  },
                                  onSuggestionSelected: (suggestion) {
                                    _destinationEditController.text =
                                        suggestion;
                                    widget._destination = suggestion;
                                  },
                                )
                              ],
                            );
                          },
                        ),
                        actionsPadding: EdgeInsets.only(bottom: 30.h),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: [
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white, // 텍스트 색 바꾸기
                              backgroundColor: _color, // 백그라운드로 컬러 설정

                              textStyle: TextStyle(fontSize: 16.sp),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(ctx);
                            },
                            child: const Text(
                              "닫기",
                              style: TextStyle(fontFamily: "cafe24_surround"),
                            ),
                          )
                        ],
                        title: Column(
                          children: [
                            Text(
                              "목적지 선택",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: "cafe24_surround"),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20.h),
                              child: Image.asset(
                                "assets/images/map.png",
                                height: (height * 0.1).h,
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
              icon: const Icon(Icons.pin_drop),
              padding: EdgeInsets.only(right: 20.w),
            )
          ],
        ),
        body: WillPopScope(
          child: Center(
            child: ChatScreen(
                myId: widget.myuserId,
                myName: widget.mynickName,
                color: _color,
                room: roomname),
          ),
          onWillPop: () {
            // Navigator.pop(context);
            Navigator.pop(context, 'refresh');
            return Future(() => false);
          },
        ));
  }

  //검색용 메소드.. 도착역검색
  List<String> getSuggestions(String query) {
    List<String> matches = [];
    matches.addAll(rain);

    matches.retainWhere((s) => s.contains(query));
    if (matches.length >= 3) {
      matches.removeRange(3, matches.length);
    }
    return matches;
  }

  void directionM() async {
    if (int.parse(widget.trainNo[widget.trainNo.length - 1]) % 2 == 0) {
      direction = 0;
    } else {
      direction = 1;
    }

    for (int i = 0; i < rain.length; i++) {
      if (widget.stationName == rain[i]) {
        point = i;
      }
    }
    widget._info = rain[point];
  }

  ////// 몇호선, 색깔 선정
  void find() {
    switch (widget.line) {
      case "1호선":
        _color = Color.fromRGBO(38, 60, 150, 1);
        rain = stationdata.one;
        break;
      case "2호선":
        _color = Color.fromRGBO(60, 180, 74, 1);
        rain = stationdata.two;
        break;
      case "3호선":
        _color = Color.fromRGBO(255, 115, 0, 1);
        rain = stationdata.three;
        break;
      case "4호선":
        _color = Color.fromRGBO(44, 158, 222, 1);
        rain = stationdata.four;
        break;
      case "5호선":
        _color = Color.fromRGBO(137, 54, 224, 1);
        rain = stationdata.five;
        break;
      case "6호선":
        _color = Color.fromRGBO(181, 80, 11, 1);
        rain = stationdata.six;
        break;
      case "7호선":
        _color = Color.fromRGBO(105, 114, 21, 1);
        rain = stationdata.seven;
        break;
      case "8호선":
        _color = Color.fromRGBO(229, 30, 110, 1);
        rain = stationdata.eight;
        break;
      case "9호선":
        _color = Color.fromRGBO(209, 166, 44, 1);
        rain = stationdata.nine;
        break;
      case "분당선":
        _color = Color.fromRGBO(255, 206, 51, 1);
        rain = stationdata.bundang;
        break;
      case "신분당선":
        _color = Color.fromRGBO(167, 30, 49, 1);
        rain = stationdata.newbundang;
        break;
      case "경의중앙선":
        _color = Color.fromRGBO(124, 196, 165, 1);
        rain = stationdata.gyeongui;
        break;
      case "경춘선":
        _color = Color.fromRGBO(8, 175, 123, 1);
        rain = stationdata.gyeongchun;
        break;
      case "공항철도":
        _color = Color.fromRGBO(115, 182, 228, 1);
        rain = stationdata.gonghang;
        break;
      case "에버라인":
        _color = Color.fromRGBO(119, 195, 113, 1);
        rain = stationdata.everline;
        break;
      default:
        break;
    }
  }
}

// --------------------------전광판 지나가는 거-----------------------------
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key, required this.text, this.color});

  final String text;
  final color;

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  //애니메이션 용ㅎ
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 5),
    vsync: this,
  )..repeat(reverse: false);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset(-0.8.w, 0),
    end: Offset(0.8.w, 0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  ));

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Padding(
        padding: EdgeInsets.all(5.w),
        child: Text(
          widget.text,
          style: TextStyle(color: widget.color),
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }
}
