import 'package:flutter/material.dart';

class AnimatedTextExample extends StatefulWidget {
  @override
  _AnimatedTextExampleState createState() => _AnimatedTextExampleState();
}

class _AnimatedTextExampleState extends State<AnimatedTextExample> {
  bool _isBig = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _isBig = !_isBig;
            });
          },
          child: AnimatedDefaultTextStyle(
            duration: Duration(seconds: 1),
            style: TextStyle(
              fontSize: _isBig ? 20 : 40,
              color: _isBig ? Colors.blue : Colors.red,
              fontWeight: FontWeight.bold,
            ),
            child: Text("Language App"),
          ),
        ),
      ),
    );
  }
}
