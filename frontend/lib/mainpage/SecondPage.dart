// import 'package:flutter/material.dart';
//
// class SecondPage extends StatelessWidget {
//   const SecondPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//           width: MediaQuery.of(context).size.width * 0.7,
//           height: MediaQuery.of(context).size.height * 0.7,
//           alignment: Alignment.center,
//           decoration:
//               BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
//           child: TextButton(
//             onPressed: () {
//               showDialog(
//                   context: context,
//                   barrierDismissible:
//                       true, // Whether you can dismiss this route by tapping the modal barrier (default : true)
//                   builder: (BuildContext ctx) {
//                     return AlertDialog(
//                       content: Text("채팅방 입장?"),
//                       actions: [
//                         TextButton(
//                           onPressed: () {
//                             Navigator.of(ctx).pop();
//                           },
//                           child: Text("ok"),
//                         )
//                       ],
//                     );
//                   });
//             },
//             child: Text(
//               "고독한 채팅방",
//               style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
