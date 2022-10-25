import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}):super(key: key);

  @override
  State<StatefulWidget> createState() => _FirstPageState();

}

class _FirstPageState extends State<FirstPage> {

  @override
  Widget build(BuildContext context) {
    final double customWidth = MediaQuery.of(context).size.width;
    final double customHeight = MediaQuery.of(context).size.height;

    // GPS 정보 받아와서 역 정보 구하면 역 이름 띄워줄 섹션 (사당)
    Widget stationNameSection = Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 50, bottom: 50),
      child: Container(
        width: customWidth * 0.7,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 2, ),
          color: Colors.white,
        ),
        child: Text("사당"),
      ),
    );

    // 역 정보 받아와서 열차 운행정보 구하면 열차 도착정보 띄워줄 섹션 (2호선, { 낙성대, 2147, 3분 }, { 방배, 2156, 2분 })
    Widget stationInfoSection = Container(
      alignment: Alignment.topCenter,
      // padding: EdgeInsets.only(top: 50),
      child: Container(
        width: customWidth * 0.85,
        height: 120,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.red, width: 2, ),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container( // beforeStation
              // alignment: Alignment.centerLeft,
              child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0x7f32a23c)
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "낙성대",
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  )
              ),
            ),
            Container( // beforeTrainInfo
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "2147",
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  Image.asset(
                    'images/train.png',
                    width: 32,
                    height: 32,
                  ),
                  Container(
                    width: ((customWidth * 0.85) - 180) / 2,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2, ),
                    ),
                  ),
                  Text(
                    "3분 후 도착",
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  )
                ],
              ),
            ),
            Container( // currentStation
              child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0x7f32a23c)
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "사당",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  )
              ),
            ),
            Container( // nextTrainInfo
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "2156",
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(3.14),
                    child: Image.asset(
                      'images/train.png',
                      width: 32,
                      height: 32,
                    ),
                  ),
                  Container(
                    // width: 100,
                    width: ((customWidth * 0.85) - 180) / 2,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2, ),
                    ),
                  ),
                  Text(
                    "2분 후 도착",
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  )
                ],
              ),
            ),
            Container( // nextStation
              // alignment: Alignment.centerRight,
              child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0x7f32a23c)
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "방배",
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  )
              ),
            ),
          ],
        ),
      ),
    );

    // 이미 타고 있어요 버튼
    Widget alreadyOnBoardSection = Container(
      // width: customWidth * 0.5,
      // height: 40,
        padding: EdgeInsets.only(top: 20, bottom: 80, left: customWidth * 0.3, right: customWidth*0.3),
        child: SizedBox(
          width: customWidth * 0.5,
          height: 40,
          child: OutlinedButton(
            onPressed: (){},
            child: Text(
              "이미 타고있어요",
              style: TextStyle(
                  fontSize: 20
              ),
            ),
          ),
        )
    );

    // 광고 섹션
    Widget advBoardSection = Container(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: customWidth * 0.85,
        height: 60,
        margin: EdgeInsets.all(20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              'images/train.png',
              width: 70,
              height: 70,
            ),
            Text(
              "광고문의 : A602팀",
              style: TextStyle(
                fontSize: 20,
              ),
            )
          ],
        ),
        // ),
      ),
    );

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 1,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            color: Color.fromARGB(1, 12, 12, 251)
        ),
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            stationNameSection,
            Expanded(
              child: ListView( // 동적 바인딩 하기 전에 테스트용 여러개 집어넣어봤음
                children: [
                  stationInfoSection,
                  stationInfoSection,
                  stationInfoSection,
                  stationInfoSection,
                  stationInfoSection,
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