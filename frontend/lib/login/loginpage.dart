import 'package:flutter/material.dart';
import 'package:practice_01/login/kakao_login_button.dart';

import 'kakao_login.dart';
import 'main_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String customFont = 'samlip_outline';
  int customColor = 0xff000000;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/loginpage-background-image.png'),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 8),
              KakaoLoginButton(),
              Spacer(flex: 2),
            ],
          )
      ),
      // child: Container(
      //     decoration: BoxDecoration(
      //       color: Color(0xffFFE15D),
      //     ),
      //     child: Center(
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           // Spacer(flex: 4),
      //           // Image.asset('assets/images/train_example.png', width: 250),
      //           // SizedBox(
      //           //   width: 360,
      //           //   child: Row(
      //           //     mainAxisAlignment: MainAxisAlignment.center,
      //           //     crossAxisAlignment: CrossAxisAlignment.end,
      //           //     children: [
      //           //       Spacer(flex: 1),
      //           //       Text('이', style: TextStyle(fontFamily: customFont, fontSize: 60, color: Color(customColor)),),
      //           //       Text('름', style: TextStyle(fontFamily: customFont, fontSize: 50, color: Color(customColor)),),
      //           //       Spacer(flex: 1),
      //           //       Text('모', style: TextStyle(fontFamily: customFont, fontSize: 60, color: Color(customColor)),),
      //           //       Text('를', style: TextStyle(fontFamily: customFont, fontSize: 50, color: Color(customColor)),),
      //           //       Spacer(flex: 1),
      //           //       Text('지', style: TextStyle(fontFamily: customFont, fontSize: 60, color: Color(customColor)),),
      //           //       Text('하철', style: TextStyle(fontFamily: customFont, fontSize: 50, color: Color(customColor)),),
      //           //       Spacer(flex: 1),
      //           //     ],
      //           //   ),
      //           // ),
      //           Spacer(flex: 2),
      //
      //           Spacer(flex: 1),
      //         ],
      //       ),
      //     )
      // )
    );
  }
}
