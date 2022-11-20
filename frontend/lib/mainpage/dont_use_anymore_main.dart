// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'Home.dart';
//
// // 스크린 유틸 추가
// // dependencies:
// //   flutter_screenutil: ^5.6.0
//
// void main() async {
//   await ScreenUtil.ensureScreenSize();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(360, 800),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (context, child) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: '탭에 나오는 페이지 타이틀이구요',
//           theme: ThemeData(
//             primarySwatch: Colors.blue,
//           ),
//           home: const MyHomePage(title: '상단에 노출되는 홈페이지 타이틀입니다'),
//         );
//       },
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   // TrainInfo trainInfo = TrainInfo.fromJson(jsonData);
//
//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.init(context, designSize: const Size(360, 800));
//     return MaterialApp(
//       home: Home(),
//     );
//   }
// }
