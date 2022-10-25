import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget{
  const SecondPage({Key? key}): super(key: key);

  // void _onItemTapped(BuildContext context){
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext ctx){
  //         return AlertDialog(
  //           content: Text("채팅방 입장?"),
  //           actions: [
  //             OutlinedButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text("입장하기"),)
  //           ],
  //         );
  //       }
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.7,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2)
          ),
          child: OutlinedButton(
            onPressed: (){
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext ctx){
                    return AlertDialog(
                      content: Text("채팅방 입장?"),
                      actions: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("입장하기"),)
                      ],
                    );
                  }
              );
            },
            child: Text(
              "고독한 채팅방",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700
              ),
            ),
          ),
        ),
      ),
    );
  }
}