// import 'package:flutter/material.dart';
//
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'TrainInfo.dart';
// import 'GetOnTrainDialog.dart';
//
// class TrainArrival extends StatefulWidget {
//   const TrainArrival(
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
//   _TrainArrivalState createState() => _TrainArrivalState();
// }
//
// class _TrainArrivalState extends State<TrainArrival> {
//   int _remainTime = 0;
//   String _arrivalInfo = "";
//   String _imagePath = "assets/images/sub_empty.png";
//
//   String setArrivalInfo(int rTime) {
//     if (rTime > 0) {
//       return "약 $rTime분 후 도착";
//     } else {
//       return "곧 도착";
//     }
//   }
//
//   @override
//   void initState() {
//     setState(() {
//       _remainTime = (widget.train.remainTime / 60).floor();
//
//       _arrivalInfo = setArrivalInfo(_remainTime);
//
//       if (_remainTime < 2) {
//         if (widget.train.direction == 1) {
//           _imagePath = "assets/images/sub_right_01.png";
//         } else {
//           _imagePath = "assets/images/sub_left_01.png";
//         }
//       } else if (_remainTime < 5) {
//         if (widget.train.direction == 1) {
//           _imagePath = "assets/images/sub_right_02.png";
//         } else {
//           _imagePath = "assets/images/sub_left_02.png";
//         }
//       } else if (_remainTime < 10) {
//         if (widget.train.direction == 1) {
//           _imagePath = "assets/images/sub_right_03.png";
//         } else {
//           _imagePath = "assets/images/sub_left_03.png";
//         }
//       } else {
//         _imagePath = "assets/images/sub_empty.png";
//       }
//     });
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         GestureDetector(
//           onTap: () => {
//             showDialog(
//                 context: context,
//                 barrierDismissible: true,
//                 builder: (BuildContext ctx) {
//                   return GetOnTrainDialog(
//                       userId: widget.userId,
//                       train: widget.train,
//                       // trainNo: int.parse(widget.train.trainNo),
//                       // line: widget.train.line!,
//                       stationName: widget.stationName);
//                   // remainTime: widget.train.remainTime);
//                 })
//           },
//           child: Container(
//             width: 100.w,
//             height: 30.h,
//             decoration: BoxDecoration(
//                 image: DecorationImage(
//                     image: AssetImage(_imagePath), fit: BoxFit.fill)),
//           ),
//         ),
//         Container(
//           width: 110.w,
//           height: 20.h,
//           alignment: Alignment.center,
//           child: Text(
//             _arrivalInfo,
//           ),
//         ),
//       ],
//     );
//   }
// }
