import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/station.dart' as stationData;
import '../widget/chat_screen.dart';

// 메시지 언제 끊을것이지...

// 채팅방있는 페이지
class TextChat extends StatefulWidget {
  //노선,열차,현재역
  final String train;
  final String room;
  final String station;
  final String rail;
  final String myuserId;
  final String mynickName;

  TextChat(
      {super.key,
      required this.train,
      required this.room,
      required this.station,
      required this.rail,
      required this.myuserId,
      required this.mynickName});

  //현재역 찾기
  late String _info = "";
  late String _destination = "역삼";

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

  //시작..
  @override
  void initState() {
    super.initState();
    widget._info = widget.station;
    find();
    makeroom();
    directionM();

    //시간마다 정보변경
    setState(() {
      _timer = Timer.periodic(Duration(seconds: 10), (timer) {
        test();
        //print(widget._info);
        if (widget._info == widget._destination) {
          _timer?.cancel();
        }
      });
    });
  }

  void makeroom(){
    roomname = widget.train + "-" + widget.room;
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
              Navigator.pop(context);
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
              child: MyStatefulWidget(text: widget._info, color: Colors.white),
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
              //경로선택 dialog
              showDialog(
                  context: context,
                  builder: (BuildContext ctx) {
                    return AlertDialog(
                      content: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TypeAheadField(
                                textFieldConfiguration: TextFieldConfiguration(
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    controller: _destinationEditController,
                                    //autofocus: true,
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .copyWith(
                                            height: 1,
                                            fontSize: 17.sp,
                                            color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: _destinationEditController.text,
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
                                    leading: Icon(Icons.train),
                                    title: Text(suggestion),
                                  );
                                },
                                onSuggestionSelected: (suggestion) {
                                  _destinationEditController.text = suggestion;
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
                            Navigator.of(ctx).pop();
                          },
                          child: const Text("닫기"),
                        )
                      ],
                      title: Column(
                        children: [
                          Text(
                            "목적지 선택",
                            textAlign: TextAlign.center,
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
      body: Center(
        child: ChatScreen(
            myId: widget.myuserId, myName: widget.mynickName, color: _color, room : roomname ),
      ),
    );
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
    if (int.parse(widget.train[widget.train.length - 1]) % 2 == 0) {
      direction = 0;
    } else {
      direction = 1;
    }

    for (int i = 0; i < rain.length; i++) {
      if (widget.station == rain[i]) {
        point = i;
      }
    }
    widget._info = rain[point];
  }

  ////// 몇호선, 색깔 선정
  void find() {
    switch (widget.rail) {
      case "1호선":
        _color = Color(0xff0D347F);
        rain = stationData.one;
        break;
      case "2호선":
        _color = Color(0xff3B9F37);
        rain = stationData.two;
        break;
      case "3호선":
        _color = Color(0xff3B9F37);
        rain = stationData.three;
        break;
      case "4호선":
        _color = Color(0xff3165A8);
        rain = stationData.four;
        break;
      case "5호선":
        _color = Color(0xff703E8C);
        rain = stationData.five;
        break;
      case "6호선":
        _color = Color(0xff904D23);
        rain = stationData.six;
        break;
      case "7호선":
        _color = Color(0xff5B692E);
        rain = stationData.seven;
        break;
      case "8호선":
        _color = Color(0xffC82363);
        rain = stationData.eight;
        break;
      case "9호선":
        _color = Color(0xffB39627);
        rain = stationData.nine;
        break;
      case "분당선":
        _color = Color(0xffDBA829);
        rain = stationData.bundang;
        break;
      case "신분당선":
        _color = Color(0xff971F2D);
        rain = stationData.newbundang;
        break;
      case "경의중앙선":
        _color = Color(0xff76B69B);
        rain = stationData.gyeongui;
        break;
      case "경춘선":
        _color = Color(0xff2D9B76);
        rain = stationData.gyeongchun;
        break;
      case "공항철도":
        _color = Color(0xff6CA8CE);
        rain = stationData.gonghang;
        break;
      case "에버라인":
        _color = Color(0xff6FB26C);
        rain = stationData.everline;
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
