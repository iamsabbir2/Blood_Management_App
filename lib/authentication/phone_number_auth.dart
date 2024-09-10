import 'package:blood_management_app/providers/user_provider.dart';
import 'package:blood_management_app/providers/verificationid_provider.dart';
import 'package:blood_management_app/splashes/welcome_splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhoneVerificationPage extends ConsumerStatefulWidget {
  PhoneVerificationPage();

  @override
  _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends ConsumerState<PhoneVerificationPage> {
  String verificationCode = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isCodeSent = false;

  void _verifyPhoneNumber() {
    final user = ref.watch(userProvider)!;
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: user.phoneNumber,
      verificationCompleted: (phoneAuthCredential) {
        print('verification completed');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Phone number verified by callback function'),
          ),
        );
      },
      verificationFailed: (verificationFailed) async {
        print('verification failed');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Phone number verification failed'),
          ),
        );

        try {
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await user.delete();
            print('User account deleted');
          }
          Navigator.of(context).pop();
        } catch (e) {
          print('Failed to delete user: $e');
        }
      },
      codeSent: (verificationId, forceResendingToken) {
        print('code sent');
        ref.read(verificationIdProvider.notifier).state = verificationId;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP sent to ${user.phoneNumber}'),
          ),
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
    setState(() {
      _isCodeSent = true;
    });
  }

  final _formKey = GlobalKey<FormState>();

  void _confirmCode() async {
    final verification = ref.watch(verificationIdProvider);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }

    print('verificationCode: $verificationCode');
    print('verification: $verification');
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verification,
        smsCode: verificationCode,
      );

      print('credential: $credential');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Phone number verified'),
        ),
      );

      User? user = _auth.currentUser;

      if (user != null) {
        await user.linkWithCredential(credential);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const WelcomeSplash(),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
        title: Text(
          'Phone Verification',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
              ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _isCodeSent
                  ? 'Enter the OTP sent to ${user.phoneNumber}'
                  : 'Click on the button below to receive the OTP',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Form(
            key: _formKey,
            child: TextFormField(
              onChanged: (value) {
                if (value.length == 6) {
                  FocusScope.of(context).unfocus();
                }
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              textAlign: TextAlign.center,
              onSaved: (value) {
                verificationCode = value!;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the OTP';
                }
                return null;
              },
            ),
          ),
          ElevatedButton(
            child: Text(_isCodeSent ? 'Verify' : 'Send OTP'),
            onPressed: _isCodeSent ? _confirmCode : _verifyPhoneNumber,
          )
        ],
      ),
    );
  }
}


// () {
//                 if (_formKey.currentState!.validate()) {
//                   _formKey.currentState!.save();

//                   ref.read(otpProvider.notifier).state = verificationCode;
//                   final otp = ref.watch(otpProvider.notifier).state;
//                   print(verificationCode);
//                   print('otp: $otp');
//                   try {
//                     final credential = PhoneAuthProvider.credential(
//                       verificationId: verificationCode,
//                       smsCode: otp,
//                     );
//                     print('credential: $credential');
//                   } catch (e) {
//                     print(e);
//                   }
//                 }
//               }