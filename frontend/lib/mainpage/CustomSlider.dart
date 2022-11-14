// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:ui' as ui;
//
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'TrainInfo.dart';
// import 'GetOnTrainDialog.dart';
//
// class CustomSlider extends StatefulWidget {
//   const CustomSlider(
//       {Key? key,
//       required this.userId,
//       required this.stationName,
//       required this.train})
//       : super(key: key);
//
//   final String userId;
//   final String stationName;
//   final Train train;
//
//   @override
//   _CustomSliderState createState() => _CustomSliderState();
// }
//
// class _CustomSliderState extends State<CustomSlider> {
//   // late ui.Image customImage;
//   ui.Image? customImage;
//   int _sliderValue = 0;
//   int _reverseSliderValue = 0;
//   int _remainTime = 0;
//
//   int _sliderButtonPaddingLeft = 0;
//   int _sliderButtonPaddingRight = 0;
//
//   String _arrivalInfo = "";
//
//   int calcSliderValue(int rTime, int dir) {
//     int sv = 0;
//     if (rTime > 9) {
//       sv = 9;
//     } else if (rTime < 0) {
//       sv = 0;
//     } else {
//       sv = rTime;
//     }
//
//     return dir == 0 ? sv : (9 - sv);
//   }
//
//   int calcPadding(int val) {
//     if (val < 1) {
//       return 0;
//     } else if (val > 8) {
//       return (125 / 9).round() * val - 24;
//     } else {
//       return (125 / 9).round() * val - 12;
//     }
//   }
//
//   String setArrivalInfo(int rTime) {
//     if (rTime > 0) {
//       return "약 $rTime분 후 도착";
//     } else {
//       return "곧 도착";
//     }
//   }
//
//   void printFunction() {
//     print("sv = $_sliderValue");
//     print("rv = $_reverseSliderValue");
//     print("rt = $_remainTime");
//
//     if (widget.train.direction == 1) {
//       print("clicked left");
//     } else {
//       print("clicked right");
//     }
//
//     print("left : $_sliderButtonPaddingLeft");
//     print("right : $_sliderButtonPaddingRight");
//
//     print(_arrivalInfo);
//   }
//
//   Future<ui.Image> loadImage(String assetPath) async {
//     ByteData data = await rootBundle.load(assetPath);
//     ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
//     ui.FrameInfo fi = await codec.getNextFrame();
//
//     return fi.image;
//   }
//
//   @override
//   void initState() {
//     loadImage('assets/images/mediumstar.png').then((image) {
//       // print(image);
//       setState(() {
//         customImage = image;
//         _remainTime = (widget.train.remainTime / 60).round();
//
//         _sliderValue = calcSliderValue(_remainTime, widget.train.direction);
//         _reverseSliderValue = 9 - _sliderValue;
//
//         _sliderButtonPaddingLeft = calcPadding(_sliderValue);
//         _sliderButtonPaddingRight = calcPadding(_reverseSliderValue);
//
//         _arrivalInfo = setArrivalInfo(_remainTime);
//       });
//     });
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (customImage != null) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 110.w,
//             height: 20.h,
//             // decoration: BoxDecoration(
//             //     border: Border.all(color: Colors.green, width: 1)),
//           ),
//           SliderTheme(
//               data: SliderThemeData(
//                 overlayShape: SliderComponentShape.noOverlay,
//                 showValueIndicator: ShowValueIndicator.always,
//                 trackShape: RectangularSliderTrackShape(),
//                 // valueIndicatorShape: ,
//                 trackHeight: 10.h,
//                 inactiveTrackColor: Colors.grey.shade300,
//                 // activeTrackColor: const Color(0xFFFFE900),
//                 activeTrackColor: Colors.grey[300],
//                 thumbShape: SliderThumbImage(customImage!),
//               ),
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   IgnorePointer(
//                       ignoring: true,
//                       child: Container(
//                         width: 110.w,
//                         height: 10.h,
//                         // decoration: BoxDecoration(
//                         //     border: Border.all(color: Colors.blue, width: 1)),
//                         child: Slider(
//                           value: _sliderValue.toDouble(),
//                           min: 0,
//                           max: 9,
//                           divisions: 10,
//                           // label: "2135",
//                           onChanged: (value) {
//                             setState(() {
//                               _sliderValue = value.toInt();
//                               print(_sliderValue);
//                             });
//                           },
//                         ),
//                       )),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: 125.w,
//                         height: 25.h,
//                         padding: EdgeInsets.only(
//                           left: (_sliderButtonPaddingLeft.w),
//                           right: (_sliderButtonPaddingRight.w),
//                         ),
//                         child: TextButton(
//                           style: TextButton.styleFrom(
//                               minimumSize: Size.zero, padding: EdgeInsets.zero),
//                           onPressed: () => {
//                             // printFunction(),
//                             // showDialogGetOnTrain(int.parse(widget.trainNo))
//                             showDialog(
//                                 context: context,
//                                 barrierDismissible: true,
//                                 builder: (BuildContext ctx) {
//                                   return GetOnTrainDialog(
//                                       userId: widget.userId,
//                                       trainNo: int.parse(widget.train.trainNo),
//                                       line: widget.train.line!,
//                                       stationName: widget.stationName,
//                                       remainTime: widget.train.remainTime);
//                                 })
//                           },
//                           child: Container(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               )),
//           Container(
//             width: 110.w,
//             height: 20.h,
//             alignment: Alignment.center,
//             // decoration: BoxDecoration(
//             //     border: Border.all(color: Colors.green, width: 1)),
//             child: Text(
//               _arrivalInfo,
//             ),
//           ),
//         ],
//       );
//     } else {
//       return Container(
//         alignment: Alignment.center,
//         child: Text("안나와"),
//       );
//     }
//   }
// }
//
// class SliderThumbImage extends SliderComponentShape {
//   final ui.Image image;
//
//   SliderThumbImage(this.image);
//
//   @override
//   Size getPreferredSize(bool isEnabled, bool isDiscrete) {
//     return const Size(0, 0);
//   }
//
//   @override
//   void paint(PaintingContext context, Offset center,
//       {required Animation<double> activationAnimation,
//       required Animation<double> enableAnimation,
//       required bool isDiscrete,
//       required TextPainter labelPainter,
//       required RenderBox parentBox,
//       required SliderThemeData sliderTheme,
//       required TextDirection textDirection,
//       required double value,
//       required double textScaleFactor,
//       required Size sizeWithOverflow}) {
//     final canvas = context.canvas;
//     final imageWidth = image.width;
//     final imageHeight = image.height;
//
//     Offset imageOffset = Offset(
//       center.dx - (imageWidth / 2),
//       center.dy - (imageHeight / 2),
//     );
//
//     Paint paint = Paint()..filterQuality = FilterQuality.high;
//
//     canvas.drawImage(image, imageOffset, paint);
//   }
// }
