import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:practice_01/mainpage/FirstPage.dart';
import 'package:practice_01/mainpage/TrainInfo.dart';
import '../screens/textchat.dart';
import 'Home.dart';
import 'TestChatPage.dart';
import 'NickGenerator.dart';

class GetOnTrainDialog extends StatefulWidget {
  const GetOnTrainDialog(
      {Key? key,
      required this.userId,
      required this.train,
      // required this.trainNo,
      // required this.line,
      required this.stationName})
      // required this.remainTime})
      : super(key: key);

  final String userId;
  final Train train;
  // final int trainNo;
  // final String line;
  final String stationName;
  // final int remainTime;

  @override
  State<StatefulWidget> createState() {
    return GetOnTrainDialogState();
  }
}

class GetOnTrainDialogState extends State<GetOnTrainDialog> {
  int _trainNo = 0;
  int _position = 1;

  @override
  void initState() {
    setState(() {
      _trainNo = int.parse(widget.train.trainNo);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      // content: Text("채팅방 입장?"),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.train.trainNo + " 열차",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(
            widget.train.detail,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          Padding(padding: EdgeInsets.only(bottom: 10.h)),
          SizedBox(
            // width: 200.w,
            height: 30.h,
            child: Container(
              alignment: Alignment.topCenter,
              child: Text(
                (widget.train.remainTime / 60).floor() > 0
                    ? (widget.train.remainTime / 60).floor().toString() +
                        " 분 후 도착"
                    : "곧 도착",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 9.sp,
                ),
              ),
            ),
          ),
          widget.train.remainTime > -1
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(padding: EdgeInsets.only(bottom: 10.h)),
                    Container(
                      // decoration: BoxDecoration(
                      //     border: Border.all(color: Colors.orange, width: 1)),
                      child: Text(
                        "핀을 움직여 탑승위치를 설정하세요",
                      ),
                    ),
                    SizedBox(
                      // width: 200.w,
                      height: 30.h,
                      // child: Container(
                      //   decoration: BoxDecoration(
                      //       border: Border.all(color: Colors.red, width: 1)),
                      // ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 10.h)),
                    // TrainPositionSlider(),
                    Container(
                      // decoration: BoxDecoration(
                      //     border: Border.all(color: Colors.orange, width: 1)),
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 10.h,
                          trackShape: RectangularSliderTrackShape(),
                          // activeTrackColor: Colors.purple.shade800,
                          // inactiveTrackColor: Colors.purple.shade100,
                          activeTrackColor: Colors.grey[300],
                          inactiveTrackColor: Colors.grey[300],

                          thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: 14.0,
                            pressedElevation: 8.0,
                          ),
                          thumbColor: Colors.grey[600],
                          // overlayColor: Colors.pink.withOpacity(0.2),
                          // overlayShape: RoundSliderOverlayShape(overlayRadius: 32.0),
                          overlayShape: SliderComponentShape.noOverlay,
                          // tickMarkShape: RoundSliderTickMarkShape(),
                          // activeTickMarkColor: Colors.white,
                          // inactiveTickMarkColor: Colors.white,
                          activeTickMarkColor: Colors.grey[300],
                          inactiveTickMarkColor: Colors.grey[300],
                          valueIndicatorShape:
                              PaddleSliderValueIndicatorShape(),
                          valueIndicatorColor: Colors.grey[600],
                          valueIndicatorTextStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20.sp,
                          ),
                        ),
                        child: Slider(
                          min: 1,
                          max: 10,
                          value: _position.toDouble(),
                          divisions: 10,
                          // label: '${_position}',
                          onChanged: widget.train.remainTime <= 60
                              ? (value) {
                                  setState(() {
                                    _position = value.round();
                                  });
                                }
                              : null,
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 10.h)),
                    Container(
                      // decoration: BoxDecoration(
                      //     border: Border.all(color: Colors.orange, width: 1)),
                      child: Text("$_position번 칸"),
                    ),
                  ],
                )
              : Container(
                  height: 30.h,
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.zero,
                  child: Text(
                    "아직 탑승할 수 없어요!",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
        ],
      ),
      actions: [
        Container(
          // color: Colors.red,
          // decoration:
          //     BoxDecoration(border: Border.all(color: Colors.blue, width: 1)),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF8EFD2),
            ),
            onPressed: widget.train.remainTime <= 60
                ? () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext ctx) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          content: Text("$_trainNo 열차 $_position번 칸에 탑승하시나요?"),
                          actions: <Widget>[
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFF8EFD2),
                                ),
                                onPressed: () async {
                                  // Navigator.of(context).pop();
                                  Navigator.of(ctx).pop();
                                  Fluttertoast.showToast(
                                    msg: " $_trainNo 열차 $_position번 칸에 탑승",
                                    fontSize: 16.sp,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.white60,
                                    textColor: Colors.black,
                                    toastLength: Toast.LENGTH_SHORT,
                                  );
                                  String refresh = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TextChat(
                                              myuserId: widget.userId,
                                              mynickName: landumeNick(),
                                              line: widget.train.line,
                                              trainNo: _trainNo.toString(),
                                              stationName: widget.stationName,
                                              position: _position.toString())));
                                  if (refresh == 'refresh') {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Home()));
                                  }
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) => TextChat(
                                  //         myuserId: widget.userId,
                                  //         mynickName: landumeNick(),
                                  //         line: widget.train.line,
                                  //         trainNo: _trainNo.toString(),
                                  //         stationName: widget.stationName,
                                  //         position: _position.toString())));
                                },
                                child: Text("네",
                                    style: TextStyle(color: Colors.black))),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[100]),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Text(
                                  "아니요",
                                  style: TextStyle(color: Colors.black),
                                ))
                          ],
                        );
                      },
                    );
                  }
                : null,
            child: Text(
              "탑승하기",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
    // throw UnimplementedError();
  }
}
