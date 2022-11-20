import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:practice_01/login/kakao_login.dart';
import 'package:practice_01/login/main_view_model.dart';
import 'package:practice_01/mainpage/Home.dart';

// 카카오톡으로 로그인하는 버튼
class KakaoLoginButton extends StatefulWidget {
  const KakaoLoginButton({Key? key}) : super(key: key);

  @override
  State<KakaoLoginButton> createState() => _KakaoLoginButtonState();
}

class _KakaoLoginButtonState extends State<KakaoLoginButton> {
  final viewModel = MainViewModel(KakaoLogin());
  bool _islogined = false;
  // bool isLoginSuccess = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (viewModel.isLogined) {
          print("로그인성공");
          Navigator.of(context).pop();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        } else {
          print("로그인안성공");
          await viewModel.login();
          await Future.delayed(Duration(milliseconds: 3000));
          Navigator.of(context).pop();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Image.asset('assets/images/icon-kakao-login.png'),
    );
  }
}
