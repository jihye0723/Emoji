import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrainPositionSlider extends StatefulWidget {
  const TrainPositionSlider({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TrainPositionSliderState();
  }
}

class TrainPositionSliderState extends State<TrainPositionSlider> {
  // ui.Image? customImage;
  int _position = 0;

  // Future<ui.Image> loadImage(String assetPath) async {
  //   ByteData data = await rootBundle.load(assetPath);
  //   ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
  //   ui.FrameInfo fi = await codec.getNextFrame();
  //
  //   return fi.image;
  // }

  // @override
  // void initState() {
  //   loadImage('assets/images/mediumstar.png').then((image) {
  //     setState(() {
  //       customImage = image;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 10.0,
        trackShape: RoundedRectSliderTrackShape(),
        activeTrackColor: Colors.purple.shade800,
        inactiveTrackColor: Colors.purple.shade100,
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: 14.0,
          pressedElevation: 8.0,
        ),
        thumbColor: Colors.pinkAccent,
        overlayColor: Colors.pink.withOpacity(0.2),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 32.0),
        tickMarkShape: RoundSliderTickMarkShape(),
        activeTickMarkColor: Colors.pinkAccent,
        inactiveTickMarkColor: Colors.white,
        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
        valueIndicatorColor: Colors.black,
        valueIndicatorTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
      child: Slider(
        min: 0.0,
        max: 100.0,
        value: _position.toDouble(),
        divisions: 10,
        label: '${_position}',
        onChanged: (value) {
          setState(() {
            _position = value.round();
          });
        },
      ),
    );
  }
}
