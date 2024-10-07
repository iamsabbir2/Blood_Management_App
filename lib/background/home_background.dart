import 'package:flutter/material.dart';

class HomeBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Color.fromRGBO(255, 23, 23, 1.0)
      ..strokeWidth = 5
      ..style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0, 0); // Left top corner
    path.lineTo(0, size.height * 0.3);
    path.quadraticBezierTo(
        0, size.height * 0.23, size.width * 0.23, size.height * 0.23);
    path.quadraticBezierTo(size.width * 0.23, size.height * 0.23,
        size.width * 0.77, size.height * 0.23);
    path.quadraticBezierTo(
        size.width, size.height * 0.23, size.width, size.height * 0.3);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
