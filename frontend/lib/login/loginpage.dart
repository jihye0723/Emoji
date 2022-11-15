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
  String customFont = 'cafe24_surround';

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
                    Spacer(flex: 1),
                    Text('이', style: TextStyle(fontFamily: customFont, fontSize: 60),),
                    Text('름', style: TextStyle(fontFamily: customFont, fontSize: 45),),
                    Spacer(flex: 1),
                    Text('모', style: TextStyle(fontFamily: customFont, fontSize: 60),),
                    Text('를', style: TextStyle(fontFamily: customFont, fontSize: 45),),
                    Spacer(flex: 1),
                    Text('지', style: TextStyle(fontFamily: customFont, fontSize: 60),),
                    Text('하철', style: TextStyle(fontFamily: customFont, fontSize: 45),),
                    Spacer(flex: 1),
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
