import 'package:flutter/material.dart';
import 'package:practice_01/login/kakao_login.dart';
import 'package:practice_01/login/main_view_model.dart';

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
            child: const Text('Login')),
      ],
    );
  }
}
