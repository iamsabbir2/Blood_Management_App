import 'package:flutter/material.dart';

class CustomScaffoldMessenger {
  final BuildContext context;
  final String message;

  CustomScaffoldMessenger({
    required this.context,
    required this.message,
  }) {
    _showMessage();
  }

  void _showMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
