import 'package:blood_management_app/authentication/phone_signin.dart';
import 'package:blood_management_app/background/home_background.dart';
import 'package:blood_management_app/providers/phone_number_provider.dart';
import 'package:blood_management_app/providers/verificationid_provider.dart';
import 'package:blood_management_app/screens/tabs.dart';
import 'package:blood_management_app/widgets/forgot_password.dart';
import 'package:blood_management_app/widgets/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() {
    return _LoginState();
  }
}

class _LoginState extends ConsumerState<Login> {
  bool _isPhone = false;
  String _email = '';
  String _password = '';
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  bool _isLoading = false;
  String _phone = '';

  Future<void> _signInWithPhone() async {
    if (_formKey2.currentState!.validate()) {
      _formKey2.currentState!.save();

      //ref.read(verificationIdProvider.notifier).state = verificationId;
      ref.read(phoneProvider.notifier).state = _phone;
      print(_phone);

      try {
        setState(() {
          _isLoading = true;
        });

        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: _phone,
          verificationCompleted: (phoneAuthCredential) {},
          verificationFailed: (error) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Verification failed: ${error}')),
            );
          },
          codeSent: (verificationId, forceResendingToken) async {
            ref.read(verificationIdProvider.notifier).state = verificationId;
            print('code sent hoyeche');

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('OTP sent to $_phone'),
              ),
            );

            await Future.delayed(Duration(seconds: 5));

            setState(() {
              _isLoading = false;
            });
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (ctx) {
              return PhoneSignIn();
            }));
          },
          codeAutoRetrievalTimeout: (verificationId) {},
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
            ),
          ),
        );

        print(e);
      }
    }
  }

  Future<void> _signin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      print('Email: $_email');
      print('Password: $_password');

      try {
        setState(() {
          _isLoading = true;
        });
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);

        setState(() {
          _isLoading = false;
        });

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => TabsScreen(),
          ),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final String _countryCode = "+880"; // Bangladesh country code

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          CustomPaint(
            size: Size(width, height),
            painter: HomeBackground(),
          ),
          Positioned(
            top:
                60, // Adjust based on your layout, slightly below "Welcome back"
            left: 20,
            child: Text(
              'Login',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white,
                  ),
            ),
          ),
          Positioned(
            top: 100, // Adjust based on your layout
            left: 20,
            child: Text(
              'Welcome back',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
            ),
          ),
          Positioned(
            top: width * 0.75, // Adjust based on your layout
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Form(
                      key: _isPhone ? _formKey2 : _formKey,
                      child: Column(
                        children: [
                          if (!_isPhone)
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                setState(() {
                                  _email = value!;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Email',
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          const SizedBox(height: 10),
                          if (!_isPhone)
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                setState(() {
                                  _password = value!;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Password',
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              obscureText: true,
                            ),
                          // if (_isPhone)
                          //   TextFormField(
                          //     validator: (value) {
                          //       if (value!.isEmpty) {
                          //         return 'Enter your phone number';
                          //       }
                          //       return null;
                          //     },
                          //     onSaved: (value) {
                          //       setState(() {
                          //         _phone = value!;
                          //       });
                          //     },
                          //     decoration: InputDecoration(
                          //       labelText: 'Phone Number',
                          //       fillColor: Colors.white,
                          //       filled: true,
                          //       border: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(8),
                          //       ),
                          //     ),
                          //     keyboardType: TextInputType.phone,
                          //   ),
                          if (_isPhone)
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter your phone number';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _phone = _countryCode + value!;
                              },
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                prefixText:
                                    _countryCode, // Display country code as prefix
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                        ],
                      )),
                  if (!_isPhone) const SizedBox(height: 20),
                  if (!_isPhone)
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ForgotPassword(),
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot password?',
                      ),
                    ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _signin,
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: const Color.fromARGB(255, 234, 1, 1),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        )),
                    child: _isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'SignIn',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),

                  if (!_isPhone)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an account?',
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SignUp(),
                              ),
                            );
                          },
                          child: const Text(
                            'SignUp',
                          ),
                        ),
                      ],
                    ),
                  if (_isPhone) const SizedBox(height: 20),
                  //const Text('Or sign in with'),
                  //const SizedBox(height: 20),
                  /* ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize:
                                const Size(double.infinity, 50), // Button size
                            backgroundColor: Colors.red[200],
                          ),
                          onPressed: () {
                            setState(() {
                              _isPhone = !_isPhone;
                            });
                          },
                          child: Text(!_isPhone
                              ? 'Sign in with phone'
                              : 'Sign in with email'),
                        ),
                        */
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
