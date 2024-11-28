import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final Function()? onPressed;
  final bool isLoading;
  final String title;
  final double? width;
  final double? height;
  final double? fontSize;

  const CustomElevatedButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.title,
    this.width,
    this.height,
    this.fontSize,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width ?? double.infinity, height ?? 50),
        backgroundColor: const Color.fromARGB(255, 234, 1, 1),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            )
          : Text(
              title,
              style: TextStyle(
                fontSize: fontSize ?? 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
    );
  }
}
