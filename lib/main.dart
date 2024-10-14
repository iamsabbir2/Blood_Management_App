//packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';
import 'package:firebase_core/firebase_core.dart';

//pages
import './widgets/signup.dart';
import './splashes/splash_page.dart';
import './widgets/login.dart';
//screeens
import './screens/request_lists.dart';
import './widgets/request.dart';
import './screens/chat_screen.dart';
import './screens/new_message_screen.dart';

//widgets
import 'widgets/auth_state_listener.dart';
import 'widgets/donors.dart';

//services
import './services/navigation_service.dart';

void main() async {
  runApp(
    SplashPage(
      key: UniqueKey(),
      onInitializationComplete: () {
        final Logger _logger = Logger();
        FirebaseMessaging.onBackgroundMessage(
            _firebaseMessageingBackgroundHandler);
        _logger.i('Firebase Messaging Background Handler initialized');

        runApp(
          const ProviderScope(
            child: MyApp(),
          ),
        );
      },
    ),
  );
}

Future<void> _firebaseMessageingBackgroundHandler(RemoteMessage message) async {
  print('Handling a backgrond message: ${message.messageId}');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Blood Management App',
        theme: ThemeData(
          iconTheme: const IconThemeData(color: Colors.red),
          textTheme: GoogleFonts.latoTextTheme(),
          appBarTheme: AppBarTheme(
            backgroundColor: const Color.fromRGBO(255, 4, 3, 1.0),
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            titleTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color.fromARGB(255, 246, 221, 219),
            selectedIconTheme: IconThemeData(
              color: Color.fromRGBO(255, 23, 23, 1.0),
            ),
          ),
        ),
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: '/',
        routes: {
          '/': (ctx) {
            return const AuthStateListener();
          },
          '/signup': (ctx) {
            return const SignUp();
          },
          '/requestList': (ctx) {
            return const RequestLists();
          },
          '/request': (ctx) {
            return const BloodRequest();
          },
          '/donors': (ctx) {
            return const DonorsList();
          },
          '/chat': (ctx) {
            return const ChatScreen();
          },
          '/login': (ctx) {
            return const Login();
          },
          '/new_message_screen': (ctx) {
            return const NewMessageScreen();
          }
        },
        // home: const AuthStateListener(),
      ),
    );
  }
}
