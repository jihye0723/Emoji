import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:practice_01/login/kakao_login.dart';
import 'package:practice_01/login/loginpage.dart';
import 'package:practice_01/login/validateToken.dart';
import 'package:practice_01/mainpage/Home.dart';
import 'package:video_player/video_player.dart';

// 메인 함수
void main() async {
  KakaoSdk.init(
    nativeAppKey: '20a57c799c063a61eaa19958e34c58cb',
  );
  await ScreenUtil.ensureScreenSize();
  runApp(const MyApp());
}

// 가장 큰 틀
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "이모지",
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: SplashScreen());
        });
  }
}

// 스플래시 스크린을 띄우는 동안, 토큰이 있는지 확인하기
/*
* To do.
*   Access 토큰 만료되었으면, Refresh 토큰이 유효한지 확인하고 재발급 받는 로직 필요.
* */
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  var userJwtToken;
  static final storage = FlutterSecureStorage();

  // 저장되어 있는 유저의 accessToken 을 확인한다.
  getUserToken() async {
    //read 를 통해 accessToken 을 불러온다. 데이터가 없을 때는 null 반환
    String? at = await storage.read(key: 'accessToken');
    String? rt = await storage.read(key: 'refreshToken');

    var jwtToken = json
        .encode({"grantType": "Bearer", "accessToken": at, "refreshToken": rt});
    setState(() {
      print(jwtToken.runtimeType);
      print(jwtToken);
      userJwtToken = jwtToken;
    });
    // return await storage.read(key: 'accessToken');
  }

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(
      'assets/images/metro-rail.mp4',
    )
      ..initialize().then((_) {})
      ..setVolume(0.0);

    //비동기로 getUserToken 함수를 실행하여 Secure Storage 정보를 불러오는 작업.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // getUserToken();
    });

    _playVideo();
  }

  void _playVideo() async {
    //playing video
    _controller.play();

    // Token 이 존재한다면,
    // if (userJwtToken != null) {
    storage.read(key: "accessToken").then((value) async {
      if (value != null) {
        print('저장되어 있는 토큰 발견!!');
        // print('userJwtToken : $userJwtToken');

        String? at = await storage.read(key: 'accessToken');
        String? rt = await storage.read(key: 'refreshToken');

        var jwtToken = json.encode(
            {"grantType": "Bearer", "accessToken": at, "refreshToken": rt});

        // 토큰 검증 validation 아직 없어서 true 로 해놓음
        // if (validateToken(jwtToken)) {
        if (true) {
          print('유효한 토큰입니다!! --> 홈 화면 이동');
          await Future.delayed(const Duration(seconds: 2));
          // Future.delayed(const Duration(seconds: 2));
          Navigator.of(context).pop();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        } else {
          print('유효하지 않은 토큰입니다!! --> 재 로그인');
          await Future.delayed(const Duration(seconds: 2));
          // Future.delayed(const Duration(seconds: 2));
          Navigator.of(context).pop();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        }
      }
      // Token 이 존재하지 않는다면,
      else {
        print('저장되어 있는 토큰이 없습니다!! --> 재 로그인');
        await Future.delayed(const Duration(seconds: 2));
        // Future.delayed(const Duration(seconds: 2));
        Navigator.of(context).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(
                  _controller,
                ))));
  }
}
