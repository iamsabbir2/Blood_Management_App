import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final Function() onPressed;
  final bool isLoading;
  final String title;
  const CustomTextButton({
    super.key,
    required this.onPressed,
    required this.title,
    required this.isLoading,
  });
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(),
            )
          : Text(title),
    );
  }
}
