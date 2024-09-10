import 'package:blood_management_app/background/home_background.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: HomeBackground(),
        child: const Center(
          child: Text(
            'Welcome to Blood Management App',
            // style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
