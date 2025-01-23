import 'dart:async';

import 'package:blood_management_app/providers/auth_provider.dart';
import 'package:blood_management_app/screens/signup.dart';
import 'package:blood_management_app/services/database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

//services
import '../pages/setup_pages.dart';
import '../services/auth_service_firebase.dart';

class EmailVerificationPage extends ConsumerStatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  ConsumerState<EmailVerificationPage> createState() {
    return _EmailVerificationState();
  }
}

class _EmailVerificationState extends ConsumerState<EmailVerificationPage> {
  Timer? _timer;
  Timer? _timer2;
  final AuthService _auth = AuthService();
  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verifyEmail();
      _startEmailVerificationCheck();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer2?.cancel();
    super.dispose();
  }

  Future<void> _verifyEmail() async {
    final authService = ref.read(authServiceProvider);

    try {
      await authService.sendEmailVerification();
    } catch (e) {
      Logger().e('Failed to send verification email: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send verification email: $e'),
          ),
        );
      }
    }
  }

  void _startEmailVerificationCheck() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      User? user = FirebaseAuth.instance.currentUser;
      await user!.reload();

      user = FirebaseAuth.instance.currentUser;

      if (user != null && user.emailVerified) {
        timer.cancel();
        if (mounted) {
          ref.read(authProvider.notifier).setUser(user);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OnboardingScreen(),
            ),
          );
        }
      }
    });
  }

  void _deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _databaseService.deleteUser(user.uid);
        await user.delete();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account deleted successfully'),
            ),
          );
        }
      }
    } catch (e) {
      Logger().e('Failed to delete account: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete account: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser!;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.red,
              child: Icon(
                Icons.email,
                size: 35,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Verify your email address',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'We have sent a verification link to ${user.email}',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 17,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'Please verify your email address to continue',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 17,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'After confirming your email address, you will be redirected to the next page',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 17,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'If you don\'t want to proceed, you can return to SignUp',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 17,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 15,
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: TextButton.icon(
              onPressed: () {
                _deleteAccount();
                if (mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const SignUp(),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.arrow_back, color: Colors.red),
              label: Text(
                'Return to SignUp',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Colors.red,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
