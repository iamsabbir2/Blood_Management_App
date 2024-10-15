import 'dart:async';
import 'dart:io';

import 'package:blood_management_app/background/home_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'custom_text_form_field.dart';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

//services
import '../services/navigation_service.dart';

//provider
import '../providers/auth_provider.dart';

//widgets
import 'postioned_text.dart';
import 'custom_elevated_button.dart';
import 'custom_text_button.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() {
    return _LoginState();
  }
}

class _LoginState extends ConsumerState<Login> {
  String? _email;
  String? _password;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late double _deviceHeight;
  late double _deviceWidth;
  String? errorMessage;
  bool _isConnected = true;

  StreamSubscription<List<ConnectivityResult>>? subscription;
  List<ConnectivityResult>? connectivityResult;
  @override
  initState() {
    super.initState();

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      setState(() {
        connectivityResult = result;

        if (connectivityResult!.contains(ConnectivityResult.none)) {
          _isConnected = false;
          Logger().i('No internet connection');
        } else {
          _isConnected = true;
          Logger().i('Internet connection available');
        }
      });
    });
  }

  @override
  void dispose() {
    subscription!.cancel();
    super.dispose();
  }

  Future<void> _signin() async {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (!_isConnected) {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text(
                  'No internet connection. Please connect your internet',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      NavigationService().goBack();
                    },
                    child: const Text('Ok'),
                  )
                ],
              );
            });
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final authService = ref.read(authServiceProvider);
      try {
        await authService.signInWithEmailAndPassword(_email!, _password!);
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'user-not-found':
              errorMessage = 'User not found';
              break;
            case 'wrong-password':
              errorMessage = 'Wrong password';
              break;
            case 'invalid-email':
              errorMessage = 'Invalid email';
              break;
            case 'invalid-credential':
              errorMessage = 'Invalid credential';
              break;
            default:
              errorMessage = 'An error occurred';
              break;
          }
        }
        if (mounted) {
          showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: Text(errorMessage!),
                  actions: [
                    TextButton(
                      onPressed: () {
                        NavigationService().goBack();
                      },
                      child: const Text('Ok'),
                    )
                  ],
                );
              });
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: kIsWeb
          ? Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome back to\nBlood Management App',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Card(
                      elevation: 10,
                      child: SizedBox(
                        width: 400,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: _form(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Stack(
              children: [
                _backgroundPaint(),
                _text(60, 'Login', 30),
                _text(100, 'Welcome back', 20),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _form(),
                ),
                if (!_isConnected)
                  const Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        'Connecting...',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _backgroundPaint() {
    return CustomPaint(
      size: Size(
        _deviceWidth,
        _deviceHeight,
      ),
      painter: HomeBackground(),
    );
  }

  Widget _text(double top, String text, double fontSize) {
    return PositionedText(
      text: text,
      top: top,
      fontSize: fontSize,
    );
  }

  Widget _textField(String title, String hintText, String regEx,
      TextInputType keyboardType, Function(String) onSaved,
      {String? errorMessage, bool? obscureText, bool? isItPassword}) {
    return CustomTextFormField(
      onSaved: onSaved,
      regEx: regEx,
      hintText: hintText,
      title: title,
      keyboardType: keyboardType,
      obscureText: obscureText,
      errorMessage: errorMessage ?? 'Please enter a valid value',
      isItPassword: isItPassword ?? false,
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _textField(
            'Email',
            'Email',
            '',
            TextInputType.emailAddress,
            (value) {
              setState(() {
                _email = value;
              });
            },
            errorMessage: 'Please enter a valid email',
          ),
          _textField(
            'Password',
            'Password',
            '',
            TextInputType.text,
            (value) {
              setState(() {
                _password = value;
              });
            },
            errorMessage: 'Please enter a valid password',
            obscureText: true,
            isItPassword: true,
          ),
          _forgotPassword(),
          const SizedBox(height: 10),
          _loginButton(),
          const SizedBox(height: 10),
          _dontHaveAnAccount(),
        ],
      ),
    );
  }

  Widget _forgotPassword() {
    return GestureDetector(
      onTap: () {},
      child: const Text(
        'Forgot password?',
      ),
    );
  }

  Widget _loginButton() {
    return CustomElevatedButton(
      isLoading: _isLoading,
      onPressed: _signin,
      title: 'Login',
    );
  }

  Widget _dontHaveAnAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Don\'t have an account?',
        ),
        CustomTextButton(
          onPressed: () {
            NavigationService().navigateToRoute('/signup');
          },
          title: 'SignUp',
        ),
      ],
    );
  }
}
