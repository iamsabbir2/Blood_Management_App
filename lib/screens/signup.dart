//packages
import 'package:blood_management_app/providers/auth_provider_firebase.dart';
import 'package:blood_management_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:blood_management_app/background/home_background.dart';
import 'package:logger/logger.dart';

//widgets
import '../widgets/custom_dropdown_button_field.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/postioned_text.dart';

//pages
import '../authentication/email_verification.dart';

//services
import '../services/navigation_service.dart';
import '../services/auth_service_firebase.dart';
import '../services/push_notification_service.dart';

//models
import '../models/user_model.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});
  @override
  ConsumerState<SignUp> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends ConsumerState<SignUp> {
  final PushNotificationService _pushNotificationService =
      PushNotificationService();
  final List<String> items = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final String _countryCode = '+880';
  String _name = '';
  String _email = '';
  String _phone = '';
  String _password = '';
  String _bloodGroup = 'A+';
  bool _donor = false;

  final _formKey = GlobalKey<FormState>();

  final AuthService auth = AuthService();
  bool _isActive = false;
  @override
  Widget build(BuildContext context) {
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
                      'Blood Management App',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                    ),
                    Text(
                      'Create Your Account',
                      style: Theme.of(context).textTheme.titleSmall,
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
                CustomPaint(
                  size: Size(
                    MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height,
                  ),
                  painter: HomeBackground(),
                ),
                _text(60, 'Sign Up', 30),
                _text(100, 'Create Your Account', 20),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: _form(),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _textField(
    String title,
    String hintText,
    String regEx,
    Function(String) onSaved, {
    String? errorMessage,
    bool? obscureText,
    TextCapitalization? textCapitalization,
    String? prefixText,
    TextInputType? keyboardType,
    TextEditingController? passwordController,
    TextEditingController? controller,
    bool isItPassword = false,
  }) {
    return CustomTextFormField(
      onSaved: onSaved,
      regEx: regEx,
      hintText: hintText,
      title: title,
      keyboardType: keyboardType,
      obscureText: obscureText,
      errorMessage: errorMessage ?? 'Please enter a valid value',
      textCapitalization: textCapitalization,
      prefixText: prefixText,
      passwordController: passwordController,
      controller: controller,
      isItPassword: isItPassword,
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _textField(
            'Name',
            'Name',
            '',
            (value) {
              _name = value;
            },
            errorMessage: 'Please enter a valid name',
            textCapitalization: TextCapitalization.words,
          ),
          _textField(
            'Email',
            'Email',
            '',
            (value) {
              _email = value;
            },
            errorMessage: 'Please enter a valid email',
            keyboardType: TextInputType.emailAddress,
          ),
          _textField(
            'Phone Number',
            'Phone Number',
            '',
            (value) {
              _phone = _countryCode + value;
            },
            errorMessage: 'Please enter a valid phone number',
            prefixText: _countryCode,
            keyboardType: TextInputType.number,
          ),
          _textField(
            'Password',
            'Password',
            '',
            (value) {
              _password = value;
            },
            errorMessage: 'Please enter a valid password',
            obscureText: true,
            controller: _passwordController,
            isItPassword: true,
          ),
          _textField(
            'Confirm Password',
            'Confirm Password',
            '',
            (value) {},
            errorMessage: 'Password does not match',
            obscureText: true,
            controller: _confirmPasswordController,
            passwordController: _passwordController,
            isItPassword: true,
          ),
          _dropdownButton(),
          _checkBox(),
          _signupButton(),
          const SizedBox(height: 8),
          _dontHaveAnAccount(),
        ],
      ),
    );
  }

  Widget _dontHaveAnAccount() {
    return Row(
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
    );
  }

  Widget _checkBox() {
    return CheckboxListTile(
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
    );
  }

  Widget _signupButton() {
    return CustomElevatedButton(
      isLoading: _isActive,
      onPressed: () async {
        setState(() {
          _isActive = true;
        });
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          final authNotifier = ref.read(authProvider.notifier);
          try {
            UserCredential? _user =
                await authNotifier.signUp(_email, _password);
            authNotifier.setUser(_user!.user);
            Logger().i('User signed up successfully ');
            String? fcmToken;
            if (!kIsWeb) {
              fcmToken = await _pushNotificationService.getFcmToken();
            }

            final user = UserModel(
              bloodGroup: _bloodGroup,
              canDonate: false,
              contact: _phone,
              email: _email,
              isContactHidden: false,
              isDonor: _donor,
              isGoingToDonate: false,
              isOnline: false,
              isTyping: false,
              lastActive: null,
              lastDonationDate: null,
              name: _name,
              totalDonations: 0,
              totalRequests: 0,
              uid: _user.user!.uid,
              wasRecentlyActive: false,
              fcmToken: fcmToken,
            );

            ref.watch(userProvider.notifier).addUser(user);
            ref.read(authProvider.notifier).setUser(_user.user);

            setState(() {
              _isActive = false;
            });

            NavigationService().goBack();
          } on FirebaseAuthException catch (e) {
            Logger().e('Failed to sign up. Error: $e');
          }
        }

        setState(() {
          _isActive = false;
        });
      },
      title: 'Sign Up',
    );
  }

  Widget _dropdownButton() {
    return CustomDropdownButtonField(
      items: items,
      hintText: 'Select your blood group',
      labelText: 'Blood Group',
      onChanged: (value) {
        _bloodGroup = value;
      },
      value: _bloodGroup,
    );
  }

  Widget _text(double top, String text, double fontSize) {
    return PositionedText(
      text: text,
      top: top,
      fontSize: fontSize,
    );
  }
}
