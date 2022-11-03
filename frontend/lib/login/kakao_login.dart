import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:practice_01/login/social_login.dart';

class KakaoLogin implements SocialLogin {
  @override
  Future<bool> login() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      // 카카오톡이 설치되어 있다면,
      if (isInstalled) {
        try {
          await UserApi.instance.loginWithKakaoTalk();
          return true;
        }
        // 카카오톡 로그인이 되지 않았을 경우(ex. 뒤로 가기 등)
        catch (error) {
          return false;
        }
      }
      // 카카오톡이 설치되어 있지 않다면,
      else {
        try {
          // 카카오 계정으로 로그인 유도
          await UserApi.instance.loginWithKakaoAccount();
          return true;
        }
        catch (error) {
          return false;
        }
      }
    }
    catch (error) {
      return false;
    }
  }
}