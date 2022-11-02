import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:subway/TrainPositionSlider.dart';

class GetOnTrainDialog extends StatefulWidget {
  const GetOnTrainDialog({Key? key, required this.trainNo}) : super(key: key);

  final int trainNo;

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
      _trainNo = widget.trainNo;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      // content: Text("채팅방 입장?"),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            // decoration: BoxDecoration(
            //     border: Border.all(color: Colors.orange, width: 1)),
            child: Text(
              _trainNo.toString() + " 열차",
            ),
          ),
          SizedBox(
            // width: 200.w,
            height: 50.h,
            // child: Container(
            //   decoration: BoxDecoration(
            //       border: Border.all(color: Colors.red, width: 1)),
            // ),
          ),
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
                tickMarkShape: RoundSliderTickMarkShape(),
                activeTickMarkColor: Colors.white,
                inactiveTickMarkColor: Colors.white,
                // activeTickMarkColor: Colors.grey[300],
                // inactiveTickMarkColor: Colors.grey[300],
                valueIndicatorShape: PaddleSliderValueIndicatorShape(),
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
                onChanged: (value) {
                  setState(() {
                    _position = value.round();
                  });
                },
              ),
            ),
          ),
          // SliderTheme(
          //   data: SliderTheme.of(context).copyWith(
          //     trackHeight: 10.h,
          //     trackShape: RectangularSliderTrackShape(),
          //     // activeTrackColor: Colors.purple.shade800,
          //     // inactiveTrackColor: Colors.purple.shade100,
          //     activeTrackColor: Colors.grey[300],
          //     inactiveTrackColor: Colors.grey[300],
          //     thumbShape: RoundSliderThumbShape(
          //       enabledThumbRadius: 14.0,
          //       pressedElevation: 8.0,
          //     ),
          //     thumbColor: Colors.grey[600],
          //     // overlayColor: Colors.pink.withOpacity(0.2),
          //     // overlayShape: RoundSliderOverlayShape(overlayRadius: 32.0),
          //     overlayShape: SliderComponentShape.noOverlay,
          //     tickMarkShape: RoundSliderTickMarkShape(),
          //     activeTickMarkColor: Colors.white,
          //     inactiveTickMarkColor: Colors.white,
          //     // activeTickMarkColor: Colors.grey[300],
          //     // inactiveTickMarkColor: Colors.grey[300],
          //     valueIndicatorShape: PaddleSliderValueIndicatorShape(),
          //     valueIndicatorColor: Colors.grey[600],
          //     valueIndicatorTextStyle: TextStyle(
          //       color: Colors.black,
          //       fontSize: 20.sp,
          //     ),
          //   ),
          //   child: Slider(
          //     min: 1,
          //     max: 10,
          //     value: _position.toDouble(),
          //     divisions: 10,
          //     // label: '${_position}',
          //     onChanged: (value) {
          //       setState(() {
          //         _position = value.round();
          //       });
          //     },
          //   ),
          // ),
          Container(
            // decoration: BoxDecoration(
            //     border: Border.all(color: Colors.orange, width: 1)),
            child: Text("$_position번 칸"),
          ),
        ],
      ),
      actions: [
        Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blue, width: 1)),
          child: TextButton(
            style: TextButton.styleFrom(
                minimumSize: Size.zero, padding: EdgeInsets.zero),
            onPressed: () {
              Navigator.of(context).pop();
              // 채팅방 페이지로 이동시켜주고, 끝나면 토스트 출력
              Fluttertoast.showToast(
                msg: " $_trainNo 열차 $_position번 칸에 탑승",
                fontSize: 16.sp,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                toastLength: Toast.LENGTH_SHORT,
              );
            },
            child: Text(
              "입장하기",
              style: TextStyle(
                fontSize: 20.sp,
              ),
            ),
          ),
        ),
      ],
    );
    // throw UnimplementedError();
  }
}
