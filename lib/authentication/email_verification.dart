import 'dart:async';

import 'package:blood_management_app/screens/tabs.dart';
import 'package:blood_management_app/widgets/signup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//services
import '../services/navigation_service.dart';

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
  Timer? _verificationTimer;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final int _verificationTimeout = 60;
  int _countDown = 30;
  bool _isResendButtonEnabled = false;
  @override
  void initState() {
    super.initState();
    _verifyEmail();
    _startEmailVerificationCheck();
    _startTime();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer2?.cancel();
    super.dispose();
  }

  void _startTime() {
    _timer2 = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countDown == 0) {
          setState(() {
            _isResendButtonEnabled = true;
          });
          _timer2?.cancel();
          _isResendButtonEnabled = true;
        } else {
          _countDown--;
        }
      });
    });
  }

  Future<void> _verifyEmail() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  void _startEmailVerificationCheck() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      User? user = FirebaseAuth.instance.currentUser;
      await user!.reload();

      user = FirebaseAuth.instance.currentUser;

      if (user != null && user.emailVerified) {
        timer.cancel();

        NavigationService().navigateToRoute('/auth');
      }
    });
  }

  void _startVerificationTimer() {
    _verificationTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
      User? user = _auth.currentUser;
      await user?.reload();

      if (user != null && user.emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email verified successfully'),
          ),
        );
      } else if (timer.tick * 10 >= _verificationTimeout) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email verification timeout'),
          ),
        );

        timer.cancel();
        _deleteAccount();
      }
    });
  }

  void _deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account deleted successfully'),
          ),
        );
      }
    } catch (e) {
      print('Failed to delete account: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete account: $e'),
      ));
    }
  }

  void _resendVerificationEmail() async {
    setState(() {
      _countDown = 30;
      _isResendButtonEnabled = false;
    });
    _startTime();
    User? user = _auth.currentUser;

    try {
      if (user != null) {
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verfication email sent to ${user.email}'),
          ),
        );
      }
    } catch (e) {
      print('Failed to send verification email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send verification email: $e'),
        ),
      );
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
            'Click on the link in 3 minutes to verify your email address',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 17,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            '${_countDown ~/ 60} : ${_countDown % 60} seconds remaining',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 17,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed:
                    _isResendButtonEnabled ? _resendVerificationEmail : null,
                child: Text(
                  'Resend email',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
              ),
              const SizedBox(
                width: 10,
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextButton.icon(
                  onPressed: () async {
                    await _auth.currentUser!.delete();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => SignUp(),
                      ),
                    );
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.red),
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
          )
        ],
      ),
    );
  }
}
