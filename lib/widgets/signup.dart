import 'dart:async';

import 'package:blood_management_app/authentication/email_verification.dart';
import 'package:blood_management_app/background/home_background.dart';
import 'package:blood_management_app/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_management_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});
  @override
  ConsumerState<SignUp> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends ConsumerState<SignUp> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _countryCode = '+880';
  var _name = '';
  var _email = '';
  var _phone = '';
  var _password = '';
  String _bloodGroup = 'A+';
  bool _donor = false;

  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _createAccount() async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: _email, password: _password);

      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': _name,
          'email': _email,
          'phoneNumber': _phone,
          'bloodGroup': _bloodGroup,
          'isDonor': _donor,
          'createdAt': Timestamp.now(),
          'serverTimeStamp': FieldValue.serverTimestamp(),
        });
      }
      // await _auth.createUserWithEmailAndPassword(
      //     email: _email, password: _password);

      //await _verifyEmail();
    } on FirebaseAuthException catch (e) {
      print('Failed to verify email : $e');
    }
  }

  Future<void> _onSaved() async {
    setState(() {
      _isActive = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final userP = ref.read(userProvider.notifier);
      final newUser = UserModel(
        name: _name,
        email: _email,
        phoneNumber: _phone,
        bloodGroup: _bloodGroup,
        isDonor: _donor,
      );

      userP.setUser(newUser);

      try {
        await _createAccount();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      } finally {
        setState(() {
          _isActive = false;
        });
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) {
            return const EmailVerificationPage(
              verificationStatus: 'Verificaition Page',
            );
          },
        ),
      );
    }
  }

  void _gotoPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) {
          return const EmailVerificationPage(
            verificationStatus: 'Verificaition Page',
          );
        },
      ),
    );
  }

  bool _isActive = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    print(width);
    print(height);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            CustomPaint(
              size: Size(
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height,
              ),
              painter: HomeBackground(),
            ),
            Positioned(
              top: 60,
              left: 20,
              child: Text(
                'Create Your \nAccount',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white,
                    ),
              ),
            ),
            Positioned(
              top: width * 0.65,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Name',
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  setState(() {
                                    _isActive = false;
                                  });
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                setState(() {
                                  _name = newValue!;
                                });
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  setState(() {
                                    _isActive = false;
                                  });
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                setState(() {
                                  _email = newValue!;
                                });
                              },
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              decoration: InputDecoration(
                                prefixText: _countryCode,
                                labelText: 'Phone Number',
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  setState(() {
                                    _isActive = false;
                                  });
                                  return 'valid phone number';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                setState(() {
                                  _phone = _countryCode + newValue!;
                                });
                              },
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  setState(() {
                                    _isActive = false;
                                  });
                                  return 'Please enter your password';
                                } else if (value.length < 8) {
                                  setState(() {
                                    _isActive = false;
                                  });
                                  return 'Password must be at least 8 characters';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                setState(() {
                                  _password = newValue!;
                                });
                              },
                              obscureText: true,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _confirmPasswordController,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  setState(() {
                                    _isActive = false;
                                  });
                                  return 'Please enter your password';
                                } else if (value != _passwordController.text) {
                                  setState(() {
                                    _confirmPasswordController.clear();
                                    _passwordController.clear();
                                    _isActive = false;
                                  });
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                              obscureText: true,
                            ),
                          ],
                        )),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        focusColor: Colors.green,
                        labelText: 'Choose your blood group',
                        border: const OutlineInputBorder(),
                        fillColor:
                            Theme.of(context).inputDecorationTheme.fillColor,
                      ),
                      value: _bloodGroup,
                      items: <String>[
                        'A+',
                        'A-',
                        'B+',
                        'B-',
                        'AB+',
                        'AB-',
                        'O+',
                        'O-',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _bloodGroup = newValue!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text(
                        'As a donor',
                      ),
                      value: _donor,
                      onChanged: (bool? value) {
                        setState(() {
                          _donor = value!;
                        });
                      },
                      activeColor: const Color.fromARGB(255, 255, 7, 7),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _isActive ? null : _onSaved,
                          //onPressed: _isActive ? null : _gotoPage,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          child: Text(
                            'Sign Up',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                          ),
                        ),
                        if (_isActive)
                          const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Sign In'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
