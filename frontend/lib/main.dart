import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:practice_01/chatpage/chat.dart';
import 'package:practice_01/login/loginpage.dart';
import 'package:practice_01/mainpage/Home.dart';
import 'package:video_player/video_player.dart';

// 메인 함수
void main() async {
  KakaoSdk.init(
    nativeAppKey: '9e8f2d7dc89324523cecae5569e5f764',
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
              title: "메인페이지",
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: SplashScreen());
        });
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
  bool weHaveToken = false;

  void hasToken() async {
    if (await AuthApi.instance.hasToken()) {
      try {
        AccessTokenInfo tokenInfo = await UserApi.instance.accessTokenInfo();
        weHaveToken = true;
        print('토큰 유효성 체크 성공 ${tokenInfo.id} ${tokenInfo.expiresIn}');
      } catch (error) {
        if (error is KakaoException && error.isInvalidTokenError()) {
          print('토큰 만료 $error');
        } else {
          print('토큰 정보 조회 실패 $error');
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(
      'assets/images/splash-subway-example1.mp4',
    )
      ..initialize().then((_) {})
      ..setVolume(0.0);

    _playVideo();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();

    if (weHaveToken) {
      /*
      * 토큰이 있다면, 홈 화면으로 넘어가면서 이메일을 같이 보내줘야 함.
      */
      // navigating to home screen
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
      // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      //토큰이 없다면, 로그인 페이지로 넘겨주어야 한다.
      // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    }
  }

  void _playVideo() async {
    //playing video
    _controller.play();
    hasToken();
    //add delay till video is complete
    await Future.delayed(const Duration(seconds: 4));
    dispose();
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
