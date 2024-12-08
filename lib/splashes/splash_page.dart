import 'package:blood_management_app/firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onInitializationComplete;
  const SplashPage({super.key, required this.onInitializationComplete});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _setup().then((_) {
        widget.onInitializationComplete();
      });
    }
    Future.delayed(
      const Duration(seconds: 2),
    ).then((_) {
      _setup().then((_) {
        widget.onInitializationComplete();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Management App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 32, 28, 28),
      ),
      home: Scaffold(
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
      ),
    );
  }

  Future<void> _setup() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _logger.i('Firebase initialized');
  }
}
