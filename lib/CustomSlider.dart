import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider(
      {Key? key,
      required this.trainNo,
      required this.remainTime,
      required this.direction})
      : super(key: key);

  final String trainNo;
  final int remainTime;
  final int direction;

  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  // late ui.Image customImage;
  ui.Image? customImage;
  int _sliderValue = 0;
  int _reverseSliderValue = 0;
  int _remainTime = 0;

  int _sliderButtonPaddingLeft = 0;
  int _sliderButtonPaddingRight = 0;

  Future<ui.Image> loadImage(String assetPath) async {
    ByteData data = await rootBundle.load(assetPath);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();

    return fi.image;
  }

  @override
  void initState() {
    loadImage('assets/images/mediumstar.png').then((image) {
      // print(image);
      setState(() {
        customImage = image;
        _remainTime = (widget.remainTime / 60).round();
        if (_remainTime > 9) {
          _sliderValue = 9;
          _reverseSliderValue = 0;
        } else {
          _sliderValue = _remainTime;
          _reverseSliderValue = (9 - _remainTime);
        }
        _sliderButtonPaddingLeft = _sliderValue * 11;
        _sliderButtonPaddingRight = _reverseSliderValue * 11;

        if (_sliderButtonPaddingLeft > 0 && _sliderButtonPaddingLeft <= 11) {
          _sliderButtonPaddingLeft = 0;
          _sliderButtonPaddingRight = 95;
        } else if (_sliderButtonPaddingRight > 0 &&
            _sliderButtonPaddingRight <= 11) {
          _sliderButtonPaddingLeft = 95;
          _sliderButtonPaddingRight = 0;
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (customImage != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SliderTheme(
              data: SliderThemeData(
                overlayShape: SliderComponentShape.noOverlay,
                showValueIndicator: ShowValueIndicator.always,
                trackShape: RectangularSliderTrackShape(),
                // valueIndicatorShape: ,
                trackHeight: 10.h,
                inactiveTrackColor: Colors.grey.shade300,
                // activeTrackColor: const Color(0xFFFFE900),
                activeTrackColor: Colors.grey[300],
                thumbShape: SliderThumbImage(customImage!),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  IgnorePointer(
                      ignoring: true,
                      child: Container(
                        width: 110.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 1)),
                        child: Slider(
                          value: (widget.direction == 1
                              ? _reverseSliderValue.toDouble()
                              : _sliderValue.toDouble()),
                          min: 0,
                          max: 9,
                          divisions: 10,
                          label: "2135",
                          onChanged: (value) {
                            setState(() {
                              _sliderValue = value.toInt();
                              print(_sliderValue);
                            });
                          },
                        ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 125.w,
                        height: 25.h,
                        padding: EdgeInsets.only(
                          left: (widget.direction == 1
                              ? _sliderButtonPaddingRight.w
                              : _sliderButtonPaddingLeft.w),
                          right: (widget.direction == 1
                              ? _sliderButtonPaddingLeft.w
                              : _sliderButtonPaddingRight.w),
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                              minimumSize: Size.zero, padding: EdgeInsets.zero),
                          onPressed: () => {
                            if (widget.direction == 1)
                              {
                                print(
                                    "clicked left : 약 $_reverseSliderValue분 후 도착"),
                                print("left : $_sliderButtonPaddingLeft"),
                                print("right : $_sliderButtonPaddingRight")
                              }
                            else
                              {
                                print("clicked right : 약 $_sliderValue분 후 도착"),
                                print("left : $_sliderButtonPaddingLeft"),
                                print("right : $_sliderButtonPaddingRight")
                              }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                          ),
                        ),
                      ),
                      // TextButton(
                      //   style: TextButton.styleFrom(
                      //     fixedSize: Size(120.w, 10.h),
                      //     // padding: EdgeInsets.only(left: 80.w),
                      //   ),
                      //   onPressed: () => {
                      //     if (widget.direction == 1)
                      //       {
                      //         print(
                      //             "clicked left : 약 $_reverseSliderValue분 후 도착")
                      //       }
                      //     else
                      //       {print("clicked right : 약 $_sliderValue분 후 도착")}
                      //   },
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //         border:
                      //             Border.all(color: Colors.black, width: 1)),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ))
        ],
      );
    } else {
      return Container(
        alignment: Alignment.center,
        child: Text("안나와"),
      );
    }
  }
}

class SliderThumbImage extends SliderComponentShape {
  final ui.Image image;

  SliderThumbImage(this.image);

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(0, 0);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    final canvas = context.canvas;
    final imageWidth = image.width;
    final imageHeight = image.height;

    Offset imageOffset = Offset(
      center.dx - (imageWidth / 2),
      center.dy - (imageHeight / 2),
    );

    Paint paint = Paint()..filterQuality = FilterQuality.high;

    canvas.drawImage(image, imageOffset, paint);
  }
}
