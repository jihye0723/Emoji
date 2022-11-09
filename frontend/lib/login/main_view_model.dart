import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:practice_01/login/social_login.dart';

class MainViewModel {
  final SocialLogin _socialLogin;
  bool isLogined = false;
  var myToken;
  User? user;
  //스토리지 생성
  static final storage = new FlutterSecureStorage();

  MainViewModel(this._socialLogin);

  Future login() async {
    // await 토큰변수 = login
    myToken = await _socialLogin.login();
    // 토큰변수? islogined=true : islogined=false;
    if (myToken != null) {
      isLogined = true;
      // myToken.body를 출력하면 postman과 동일한 결과 출력.(==response.body)
      print(myToken.body);

      /*
      * !!!!내일 여기부터!!!! 아래 수정해야 한다!!
      */

      String accessToken = myToken['accessToken'];

      Map<String, dynamic> payload = Jwt.parseJwt(accessToken);

      print('페이로드입니다');
      print(payload);
      // user = await UserApi.instance.me();
    }

    // isLogined = await _socialLogin.login();
    // if (isLogined) {
    //   user = await UserApi.instance.me();
    // }
  }
}