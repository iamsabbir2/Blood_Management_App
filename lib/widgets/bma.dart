import 'package:flutter/material.dart';

class BloodManagementApp extends StatefulWidget {
  const BloodManagementApp({super.key});

  @override
  State<BloodManagementApp> createState() {
    return _BloodManagementAppState();
  }
}

class _BloodManagementAppState extends State<BloodManagementApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Blood Management App'),
      ),
      body: Center(
        child: Text(
          'Welcome',
        ),
      ),
    );
  }
}
