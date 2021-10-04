import 'package:flutter/material.dart';

class Drawhorizontalline extends CustomPainter {

  Paint _paint;
  bool reverse;

  Drawhorizontalline(this.reverse) {
    _paint = Paint()
      ..color = Color(0xff212435)
      ..strokeWidth = 0.5
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if(!reverse){
      canvas.drawLine(Offset(10.0, 0.0), Offset(90.0, 0.0), _paint);
    }
    else
    {
      canvas.drawLine(Offset(-90.0, 0.0), Offset(-10.0, 0.0), _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}