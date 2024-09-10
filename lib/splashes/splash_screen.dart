import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: CustomPaint(
        size: const Size(200, 200),
        painter: Paint1(),
      ),
    ));
  }
}

class BloodDropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    // Drawing a simple blood drop shape
    Path path = Path();

    // Start from the top of the drop
    path.moveTo(size.width * 0.5, size.height * 0.5);

    path.quadraticBezierTo(size.width, size.height, 0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class PersonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0;

    // Head - Draw a circle for the head
    final headCenter = Offset(size.width / 2, size.height / 4);
    final headRadius = size.height / 8;
    canvas.drawCircle(headCenter, headRadius, paint);

    // Body - Draw a line for the body
    final bodyStart = Offset(size.width / 2, size.height / 4 + headRadius);
    final bodyEnd = Offset(size.width / 2, size.height * 3 / 4);
    canvas.drawLine(bodyStart, bodyEnd, paint);

    // Arms - Draw lines for arms
    final leftArmStart = Offset(size.width / 2 - headRadius, size.height / 2);
    final leftArmEnd = Offset(size.width / 4, size.height / 2);
    canvas.drawLine(leftArmStart, leftArmEnd, paint);

    final rightArmStart = Offset(size.width / 2 + headRadius, size.height / 2);
    final rightArmEnd = Offset(size.width * 3 / 4, size.height / 2);
    canvas.drawLine(rightArmStart, rightArmEnd, paint);

    // Legs - Draw lines for legs
    final leftLegStart = bodyEnd;
    final leftLegEnd = Offset(size.width / 3, size.height);
    canvas.drawLine(leftLegStart, leftLegEnd, paint);

    final rightLegStart = bodyEnd;
    final rightLegEnd = Offset(size.width * 2 / 3, size.height);
    canvas.drawLine(rightLegStart, rightLegEnd, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Paint1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path.moveTo(0, size.height * 0.25);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.20,
        size.width * 0.5, size.height * 0.25);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.30, size.width, size.height * 0.25);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
