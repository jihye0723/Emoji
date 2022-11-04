import 'package:flutter/material.dart';
import 'package:practice_01/login/kakao_login.dart';
import 'package:practice_01/login/main_view_model.dart';

// 카카오톡으로 로그인하는 버튼
class KakaoLoginButton extends StatefulWidget {
  const KakaoLoginButton({Key? key}) : super(key: key);

  @override
  State<KakaoLoginButton> createState() => _KakaoLoginButtonState();
}

class _KakaoLoginButtonState extends State<KakaoLoginButton> {
  final viewModel = MainViewModel(KakaoLogin());
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${viewModel.isLogined}'),
        ElevatedButton(
          onPressed: () async {
            await viewModel.login();
            setState(() {
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
          ),
          child: Image.asset('assets/images/icon-kakao-login.png'),
        ),
      ],
    );
  }
}
