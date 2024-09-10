import 'package:blood_management_app/background/home_background.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  var _isLogin = true;
  var _isActive = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    print(width);
    print(height);
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              child: CustomPaint(
                size: Size(MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height),
                painter: HomeBackground(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 180),
              width: double.infinity,
              alignment: Alignment.bottomCenter,
              child: Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (!_isLogin)
                            TextFormField(
                              decoration: const InputDecoration(
                                label: Text(
                                  'Full Name',
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              label: Text(
                                'Email',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (!_isLogin)
                            TextFormField(
                              decoration: const InputDecoration(
                                label: Text(
                                  'Phone',
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              label: Text(
                                'Password',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (!_isLogin)
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Choose your blood group',
                                border: OutlineInputBorder(),
                              ),
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
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                print(newValue);
                              },
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (!_isLogin)
                            CheckboxListTile(
                              title: const Text(
                                'As a donor',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              value: _isActive,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isActive = value!;
                                });
                              },
                              activeColor: const Color.fromARGB(255, 255, 7, 7),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              padding: const EdgeInsets.only(
                                top: 10,
                                left: 60,
                                right: 60,
                                bottom: 10,
                              ),
                            ),
                            child: Text(
                              _isLogin ? 'Sign In' : 'SignUp',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                  _isActive = _isActive ? false : _isActive;
                                });
                              },
                              child: Text(
                                _isLogin
                                    ? 'Don\'t have an account? SignUp'
                                    : 'I already have an account',
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
