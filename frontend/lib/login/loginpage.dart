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

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          decoration: BoxDecoration(
            color: Color(0xffFFE15D),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(flex: 2),
                Image.asset('assets/images/train_example.png', width: 250),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('이', style: TextStyle(fontFamily: 'samlip_outline', fontSize: 70),),
                    Text('름 ', style: TextStyle(fontFamily: 'samlip_outline', fontSize: 50),),
                    Text('모', style: TextStyle(fontFamily: 'samlip_outline', fontSize: 70),),
                    Text('를 ', style: TextStyle(fontFamily: 'samlip_outline', fontSize: 50),),
                    Text('지', style: TextStyle(fontFamily: 'samlip_outline', fontSize: 70),),
                    Text('하철', style: TextStyle(fontFamily: 'samlip_outline', fontSize: 50),),
                  ],
                ),
                Spacer(flex: 1),
                KakaoLoginButton(),
                Spacer(flex: 2),
              ],
            ),
          )
      )
    );
  }
}
