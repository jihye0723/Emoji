// import 'package:dart_image_slider/dart_image_slider.dart';

// 1. xlider 이용해서 이미지로 thumb shape 사용하기 --> 지원중단 야발 --> 실패
// https://pub.dev/packages/flutter_xlider

// 2. SliderComponentShape 상속 클래스 만들어서 자체 이미지를 thumb Image 로 사용하기
// https://blog.logrocket.com/flutter-slider-widgets-deep-dive-with-examples/#getting-started
// https://stackoverflow.com/questions/57057765/how-to-customize-slider-widget-in-flutter
// https://stackoverflow.com/questions/58116843/flutter-how-to-add-thumb-image-to-slider
// https://stackoverflow.com/questions/70786192/flutter-change-slider-thumb-to-image
// https://stackoverflow.com/questions/73735773/how-can-i-build-the-following-thumb-for-a-slider/73872457#73872457

// CustomSlider.dart 참고
// 여러가지로 따라해봤는데, 렌더링 전에 이미지 불러오는 과정에서 에러
// late 변수, nullable initialize, nullcheck operator on null, 등등..
// 근본적인 원인은 빌드(렌더링) 과정을 정확하게 이해하지 못한거같음..

// 3. 한달 전 새로나온 라이브러리 dart_image_slider 사용해보기 (0.0.1 버전...)
// https://pub.dev/packages/dart_image_slider/example
// ...

// 4. Flutter Repository (https://pub.dev/) 필요한거 찾아서 다 때려박기
