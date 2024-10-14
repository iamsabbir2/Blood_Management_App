import 'package:flutter/material.dart';

//services
import '../services/navigation_service.dart';

//widgets

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      NavigationService().removeAndNavigateToRoute('/auth');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 200,
          width: 200,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/donor.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
