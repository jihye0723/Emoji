import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:practice_01/chatpage/chat.dart';
import 'package:practice_01/login/loginpage.dart';
import 'package:practice_01/mainpage/Home.dart';
import 'package:video_player/video_player.dart';

// 메인 함수
void main() async {
  KakaoSdk.init(nativeAppKey: '9e8f2d7dc89324523cecae5569e5f764',);
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
          title: "메인페이지",
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: SplashScreen()
        );
      }
    );
  }
}

// 스플래시 스크린을 띄우는 동안, 토큰이 있는지 확인하기
/*
* To do..
*   Access 토큰 만료되었으면, Refresh 토큰이 유효한지 확인하고 재발급 받는 로직 필요.
* */
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  String? userAccessToken;
  static final storage = FlutterSecureStorage();

  // 저장되어 있는 유저의 accessToken 을 확인한다.
  getUserToken() async {
    //read 를 통해 accessToken 을 불러온다. 데이터가 없을 때는 null 반환
    userAccessToken = await storage.read(key: 'accessToken');
    return userAccessToken;
  }

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(
      'assets/images/splash-subway-example1.mp4',
    )
      ..initialize().then((_) {})
      ..setVolume(0.0);

    //비동기로 getUserToken 함수를 실행하여 Secure Storage 정보를 불러오는 작업.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserToken();
    });

    _playVideo();
  }

  void _playVideo() async {
    //playing video
    _controller.play();
    //add delay till video is complete
    await Future.delayed(const Duration(seconds: 4));

    // 이미 저장되어 있는 AccessToken 이 존재한다면,
    if (userAccessToken != null) {
      // 홈 화면으로 이동하게 된다.
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    }
    // 저장되어 있는 AccessToken 이 존재하지 않는다면,
    else {
      // 로그인 페이지로 이동하게 된다.
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
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
        child:AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(
            _controller,
          )
        )
      )
    );
  }
}

