import 'package:flutter/material.dart';

class FormErrorText extends StatelessWidget {
  final String errorMessage;

  const FormErrorText({
    Key? key,
    required this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Text(
        errorMessage,
        style: TextStyle(
          color: Colors.red,
          fontSize: 14,
        ),
      ),
    );
  }
}
