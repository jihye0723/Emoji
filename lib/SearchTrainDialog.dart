// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'GetOnTrainDialog.dart';
//
// class SearchTrainDialog extends StatelessWidget {
//   SearchTrainDialog({Key? key}) : super(key: key);
//
//   final searchTrainController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     int _trainNo = 0;
//
//     return AlertDialog(
//       // content: Text("채팅방 입장?"),
//       content: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             "열차번호 조회",
//           ),
//           TextField(
//             maxLength: 6,
//             keyboardType: TextInputType.number,
//             inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//             controller: searchTrainController,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: '열차번호',
//               counterText: "",
//             ),
//           ),
//           SizedBox(height: 30.h),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             if (searchTrainController.text.length >= 4) {
//               Navigator.of(context).pop();
//               showDialog(
//                   context: context,
//                   barrierDismissible: true,
//                   builder: (BuildContext ctx) {
//                     return GetOnTrainDialog(
//                       trainNo: int.parse(searchTrainController.text),
//                       remainTime: 0,
//                     );
//                   });
//             } else {}
//           },
//           child: Text(
//             "조회",
//             style: TextStyle(fontSize: 20.sp),
//           ),
//         )
//       ],
//     );
//     // throw UnimplementedError();
//   }
// }
