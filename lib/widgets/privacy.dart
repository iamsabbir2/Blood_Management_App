import 'package:flutter/material.dart';

class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  State<Privacy> createState() {
    return _PrivacyState();
  }
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
        title: const Text(
          'Privacy',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
