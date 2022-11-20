import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:practice_01/login/social_login.dart';

class MainViewModel {
  final SocialLogin _socialLogin;
  bool isLogined = false;
  var jwtToken;
  User? user;
  //스토리지 생성
  static final storage = FlutterSecureStorage();

  MainViewModel(this._socialLogin);

  login() async {
    // await 토큰변수 = login
    // isLogined = await _socialLogin.login();
    _socialLogin.login().then((value) {
      isLogined = value;
    });

    // 토큰변수? islogined=true : islogined=false;
    // if (jwtToken != null) {
    //   isLogined = true;

    // jwtToken.body 는 postman 에서의 response.body 와 같은 결과를 출력한다.
    // accessToken 과 refreshToken 을 각각 추출하였다.
    // String accessToken = json.decode(jwtToken.body)['accessToken'];
    // String refreshToken = json.decode(jwtToken.body)['refreshToken'];

    // accessToken 을 해독하여 만료일자인 exp 를 알 수 있음 => payload['exp']로 접근.
    // Map<String, dynamic> payload = Jwt.parseJwt(accessToken);
    // print(payload);
    // print('페이로드입니다!!!!!!!');

    // user = await UserApi.instance.me();

    // await storage.write(key: "accessToken", value: accessToken);
    // await storage.write(key: "refreshToken", value: refreshToken);
    // }
  }
}
