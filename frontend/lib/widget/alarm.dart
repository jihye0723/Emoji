import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 알람용
Widget alarm(BuildContext context, String nickName, String text) {
  return
      // 리스트뷰에 추가될 컨테이너 위젯
      Container(
    margin: const EdgeInsets.symmetric(vertical: 10.0) +
        const EdgeInsets.only(right: 5.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 입력받은 메시지 출력
            Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: EdgeInsets.only(top: 5.h),
              padding: EdgeInsets.all(8.w),
              child: Text(text),
            ),
          ],
        )
      ],
    ),
  );
}
