import 'package:flutter/material.dart';

class PositionedText extends StatelessWidget {
  final double top;
  final String text;
  final double fontSize;
  const PositionedText({
    super.key,
    required this.top,
    required this.text,
    required this.fontSize,
  });
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: 20,
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              color: Colors.white,
            ),
      ),
    );
  }
}
