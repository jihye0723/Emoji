import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final searchTrainController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final double customWidth = MediaQuery.of(context).size.width;
    // final double customHeight = MediaQuery.of(context).size.height;
    //
    // final double stationNameSectionWidth = customWidth * 0.7;
    // final double stationInfoSectionWidth = customWidth * 0.85;
    // final double railBoxWidth = ((customWidth * 0.85) - 180) / 2;
    //
    // final double alreadyOnBoardSectionWidth = customWidth * 0.5;
    // final double advBoardSectionWidth = customWidth * 0.85;

    sdt(int trainNo) {
      showDialog(
          context: context,
          barrierDismissible:
              true, // Whether you can dismiss this route by tapping the modal barrier (default : true)
          builder: (BuildContext ctx) {
            return AlertDialog(
              // content: Text("채팅방 입장?"),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    trainNo.toString() + " 열차",
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    "핀을 움직여 탑승위치를 설정하세요",
                  ),
                  Container(
                    // 이걸 슬라이드로 바꿀 예정
                    width: 200.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange, width: 1)),
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    "입장하기",
                    style: TextStyle(
                      fontSize: 20.sp,
                    ),
                  ),
                )
              ],
            );
          });
    }

    ;

    sdc() {
      showDialog(
          context: context,
          barrierDismissible:
              true, // Whether you can dismiss this route by tapping the modal barrier (default : true)
          builder: (BuildContext ctx) {
            return AlertDialog(
              // content: Text("채팅방 입장?"),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "열차번호 조회",
                  ),
                  TextField(
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: searchTrainController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '열차번호',
                      counterText: "",
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (searchTrainController.text.length >= 4) {
                      Navigator.of(ctx).pop();
                      sdt(int.parse(searchTrainController.text));
                    } else {}
                  },
                  child: Text(
                    "조회",
                    style: TextStyle(fontSize: 20.sp),
                  ),
                )
              ],
            );
          });
    }

    ;

    // final double

    // GPS 정보 받아와서 역 정보 구하면 역 이름 띄워줄 섹션 (사당)
    Widget stationNameSection = Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 30.h, bottom: 30.h),
      child: Container(
        width: 240.w,
        height: 60.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
          color: Colors.white,
        ),
        child: Text(
          "사당",
          style: TextStyle(
            fontSize: 32.sp,
          ),
        ),
      ),
    );

    // 역 정보 받아와서 열차 운행정보 구하면 열차 도착정보 띄워줄 섹션 (2호선, { 낙성대, 2147, 3분 }, { 방배, 2156, 2분 })
    Widget stationInfoSection = Container(
      alignment: Alignment.topCenter,
      child: Container(
        width: 320.w,
        height: 120.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red,
            width: 1,
          ),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              // beforeStation
              // alignment: Alignment.centerLeft,
              child: Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0x7f32a23c)),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "낙성대",
                      style: TextStyle(
                        fontSize: 10.sp,
                      ),
                    ),
                  )),
            ),
            Container(
              // beforeTrainInfo
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10.w),
                        // right: 200,
                        // top: 400,
                        child: TextButton(
                          onPressed: () {
                            // double www = context
                            print(context.size);
                            sdt(2147);
                          },
                          child: Stack(
                            children: [
                              Text(
                                "2147",
                                style: TextStyle(
                                  fontSize: 10.sp,
                                ),
                              ),
                              Image.asset(
                                'assets/images/train.png',
                                width: 30.w,
                              ),
                            ],
                          ),
                          // child: Text("test"),
                        ),
                      )
                    ],
                  ),
                  Container(
                    // width: 100,
                    width: 80.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                  ),
                  Text(
                    "3분 후 도착",
                    style: TextStyle(
                      fontSize: 10.sp,
                    ),
                  )
                ],
              ),
            ),
            Container(
              // currentStation
              child: Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0x7f32a23c)),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "사당",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 10.sp,
                      ),
                    ),
                  )),
            ),
            Container(
              // nextTrainInfo
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 10.w),
                        // right: 200,
                        // top: 400,
                        child: TextButton(
                          // 슬라이더 이용해서
                          onPressed: () {
                            print(context.size);
                            sdt(2156);
                          },
                          child: Stack(
                            children: [
                              Text(
                                "2156",
                                style: TextStyle(
                                  fontSize: 10.sp,
                                ),
                              ),
                              Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(3.14),
                                child: Image.asset(
                                  'assets/images/train.png',
                                  width: 30.w,
                                ),
                              ),
                            ],
                          ),
                          // child: Text("test"),
                        ),
                      )
                    ],
                  ),
                  Container(
                    // width: 100,
                    width: 80.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                  ),
                  Text(
                    "2분 후 도착",
                    style: TextStyle(
                      fontSize: 10.sp,
                    ),
                  )
                ],
              ),
            ),
            Container(
              // nextStation
              // alignment: Alignment.centerRight,
              child: Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0x7f32a23c)),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "방배",
                      style: TextStyle(
                        fontSize: 10.sp,
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );

    // 이미 타고 있어요 버튼
    Widget alreadyOnBoardSection = Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(
          top: 10.h,
          bottom: 10.h,
        ),
        // left: customWidth * 0.3,
        // right: customWidth * 0.3),
        child: SizedBox(
          width: 180.w,
          height: 40.h,
          child: OutlinedButton(
            onPressed: () {
              sdc();
            },
            child: Text(
              "이미 타고있어요",
              style: TextStyle(fontSize: 20.sp),
            ),
          ),
        ));

    // 광고 섹션
    Widget advBoardSection = Container(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 320.w,
        height: 60.h,
        margin: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              'assets/images/train.png',
              width: 70.w,
              height: 70.h,
            ),
            Text(
              "광고문의 : A602팀a",
              style: TextStyle(
                fontSize: 20.sp,
              ),
            )
          ],
        ),
        // ),
      ),
    );

    return Scaffold(
      body: Container(
        width: 1.sw,
        height: 1.sh,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            color: Color.fromARGB(1, 12, 12, 251)),
        alignment: Alignment.topCenter,
        child: Column(
          // <페이지 구조>
          // 현재 역 이름
          // 열차 도착정보 + 이미 (ListView)
          // 광고판
          children: <Widget>[
            stationNameSection,
            Expanded(
              child: ListView(
                // 동적 바인딩 하기 전에 테스트용 여러개 집어넣어봤음
                children: [
                  stationInfoSection,
                  stationInfoSection,
                  stationInfoSection,
                  // stationInfoSection,
                  // stationInfoSection,
                  alreadyOnBoardSection
                ],
              ),
            ),
            advBoardSection,
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
