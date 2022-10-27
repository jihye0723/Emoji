import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _text = "역삼역";
  static const _color = Colors.green;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "채팅",
      home: Scaffold(

        appBar: AppBar(
          leading: new IconButton(onPressed: (){print("back");}, icon: new Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          title: Container(
            width: 200,
            child: MyStatefulWidget(text: _text, color:_color),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          backgroundColor: _color,
          actions: <Widget>[
            new IconButton(onPressed: (){print("hihi");}, icon: new Icon(Icons.pin_drop), )
          ],
        ),

        body: const Center(
          child: MyStatefulWidget(text: "hi",color:_color),
        ),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key, required this.text, this.color});
  final String text;
  final color;

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: false);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(-0.5, 0),
    end: const Offset(1.0,0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  ));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Padding(
        padding: EdgeInsets.all(6.0),
        child: Text(widget.text, style: TextStyle( color: widget.color),),

      ),
    );
  }
}
