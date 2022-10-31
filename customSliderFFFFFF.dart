import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:basic_flutter_01/SliderThumbImage.dart';
import 'dart:ui' as ui;

class customSlider extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _customSliderState();
    // throw UnimplementedError();
  }
}

class _customSliderState extends State<customSlider> {
  // ui.Image? _customImage;

  late Future<ui.Image> _customImage;
  int _progress = 1;

  Future<ui.Image> loadImage() async {
    ByteData data = await rootBundle.load('images/train.png');
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  @override
  void initState() {
    super.initState();
    // loadImage('assets/images/train.png').then((image) {
    //   setState(() {
    //     _customImage = image;
    //   });
    // });
    // setState(() {
    //   _customImage = loadImage('images/train.png');
    // });
    _customImage = loadImage();
  }

  @override
  Widget build(BuildContext context) {
    // return SliderTheme(
    //   data: SliderThemeData(
    //     trackHeight: 28,
    //     inactiveTrackColor: Colors.grey.shade300,
    //     activeTrackColor: const Color(0xFFFFE900),
    //     thumbShape: SliderThumbImage(_customImage),
    //   ),
    //   child: Slider(
    //     value: 50,
    //     min: 0,
    //     max: 100,
    //     onChanged: (value) {},
    //   ),
    // );

    return FutureBuilder<ui.Image>(
        future: _customImage,
        builder: (context, snapshot) {
          if (snapshot.hasData || snapshot.data != null) {
            return SliderTheme(
              data: SliderThemeData(
                trackHeight: 28,
                inactiveTrackColor: Colors.grey.shade300,
                activeTrackColor: const Color(0xFFFFE900),
                thumbShape: SliderThumbImage(snapshot.data!),
              ),
              child: Slider(
                value: 50,
                min: 0,
                max: 100,
                onChanged: (value) {},
              ),
            );
          }
          // progress indicator while loading image,
          // you can return and empty Container etc. if you like
          return CircularProgressIndicator();
        });
  }

// @override
// Widget build(BuildContext context) {
//   showTrack() {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(10.w, 300.h, 10.w, 23.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             height: 20.0.h,
//             width: 0.08.sw,
//             color: Colors.blueGrey,
//           ),
//           const Spacer(),
//           Container(
//             height: 20.0.h,
//             width: 0.08.sw,
//             color: Colors.blueGrey,
//           ),
//           const Spacer(),
//           Container(
//             height: 20.0.h,
//             width: 0.08.sw,
//             color: Colors.blueGrey,
//           ),
//           const Spacer(),
//           Container(
//             height: 20.0.h,
//             width: 0.08.sw,
//             color: Colors.blueGrey,
//           ),
//           const Spacer(),
//           Container(
//             height: 20.0.h,
//             width: 0.08.sw,
//             color: Colors.blueGrey,
//           ),
//           const Spacer(),
//           Container(
//             height: 20.0.h,
//             width: 0.08.sw,
//             color: Colors.blueGrey,
//           ),
//           const Spacer(),
//           Container(
//             height: 20.0.h,
//             width: 0.08.sw,
//             color: Colors.blueGrey,
//           ),
//           const Spacer(),
//           Container(
//             height: 20.0.h,
//             width: 0.08.sw,
//             color: Colors.blueGrey,
//           ),
//           const Spacer(),
//           Container(
//             height: 20.0.h,
//             width: 0.08.sw,
//             color: Colors.blueGrey,
//           ),
//           const Spacer(),
//           Container(
//             height: 20.0.h,
//             width: 0.08.sw,
//             color: Colors.blueGrey,
//           ),
//           // const Spacer(),
//           // Container(
//           //   height: 20.0.h,
//           //   width: 40.0.w,
//           //   color: Colors.blueGrey,
//           // ),
//         ],
//       ),
//     );
//   }
//
//   if (_customImage != null) {
//     return Scaffold(
//       body: Column(
//         children: [
//           SliderTheme(
//               data: SliderThemeData(
//                   tickMarkShape: SliderTickMarkShape.noTickMark,
//                   trackHeight: 5.h,
//                   disabledActiveTickMarkColor: Colors.green,
//                   // inactiveTrackColor: Colors.amber,
//                   inactiveTrackColor: Colors.amber[200],
//                   // activeTrackColor: Colors.amber,
//                   activeTrackColor: Colors.amber[200],
//                   thumbColor: Colors.white,
//                   thumbShape:
//                       // const RoundSliderThumbShape(enabledThumbRadius: 10),
//                       _customImage != null
//                           ? RoundSliderThumbShape(enabledThumbRadius: 10)
//                           : SliderThumbImage(_customImage as ui.Image)),
//               child: Stack(
//                 children: [
//                   showTrack(),
//                   Padding(
//                     // padding: EdgeInsets.only(top: 12.h),
//                     padding: EdgeInsets.only(top: 120.h),
//                     child: Slider(
//                       label: "$_progress 번째 칸",
//                       value: _progress.toDouble(),
//                       min: 1,
//                       max: 10,
//                       divisions: 9,
//                       onChanged: (value) {
//                         setState(() {
//                           _progress = value.toInt();
//                           print(_progress);
//                           print(_customImage != null);
//                         });
//                       },
//                     ),
//                   )
//                 ],
//               ))
//         ],
//       ),
//     );
//   }
//   return Container();
//
//   // throw UnimplementedError();
// }
}
