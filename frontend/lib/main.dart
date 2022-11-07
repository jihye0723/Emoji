import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
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
          home: Scaffold()
        );
      }
    );
  }
}

// 스플래시 스크린을 띄우는 동안, 토큰이 있는지 확인하기
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(
      'assets/images/splash-subway-example1.mp4',
    )
      ..initialize().then((_) {
        setState(() {});
      })
      ..setVolume(0.0);

    _playVideo();
  }

  void _playVideo() async {
    //playing video
    _controller.play();
    //add delay till video is complete
    await Future.delayed(const Duration(seconds: 4));
    // navigating to home screen
    Navigator.pushNamed(context, '/');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(
                  _controller,
                )
              )
            : Container(),

      )
    );
  }
}

