import 'package:blood_management_app/providers/verificationid_provider.dart';
import 'package:blood_management_app/splashes/welcome_splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhoneSignIn extends ConsumerWidget {
  const PhoneSignIn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();

    String verificationCode = '';

    void _verify() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        print('Verification Code: $verificationCode');
        final v_id = ref.watch(verificationIdProvider.notifier).state;
        try {
          final credential = PhoneAuthProvider.credential(
            verificationId: v_id,
            smsCode: verificationCode,
          );

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Verification completed'),
          ));

          await Future.delayed(
            Duration(seconds: 3),
          );

          final user =
              await FirebaseAuth.instance.signInWithCredential(credential);
          print('User: $user');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Phone number verified'),
          ));

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => WelcomeSplash(),
            ),
          );
        } catch (e) {
          print(e);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('An error occurred $e'),
          ));
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Verification'),
      ),
      body: Column(
        children: [
          Text('A verfication code just sent to '),
          Form(
            key: _formKey,
            child: TextFormField(
              decoration: InputDecoration(
                label: Text('Verification Code'),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the verification code';
                }
                if (value.length != 6) {
                  return 'Please enter a valid verification code';
                }
                return null;
              },
              onSaved: (value) {
                verificationCode = value!;
              },
            ),
          ),
          ElevatedButton(
            onPressed: _verify,
            child: Text('Verify'),
          ),
        ],
      ),
    );
  }
}
