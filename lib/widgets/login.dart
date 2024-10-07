import 'package:blood_management_app/background/home_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'custom_text_form_field.dart';
import 'package:flutter/foundation.dart';

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

  Future<void> _signin() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final authService = ref.read(authServiceProvider);
      try {
        await authService.signInWithEmailAndPassword(_email!, _password!);
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        if (e == 'user-not-found') {
          errorMessage = 'User not found';
        } else if (e == 'wrong-password') {
          errorMessage = 'Wrong password';
        } else if (e == 'invalid-email') {
          errorMessage = 'Invalid email';
        } else if (e == 'user-disabled') {
          errorMessage = 'User disabled';
        } else if (e == 'too-many-requests') {
          errorMessage = 'Too many requests';
        } else if (e == 'wrong-password') {
          errorMessage = 'Wrong password';
        } else {
          errorMessage = 'An error occurred';
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
                    )
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
