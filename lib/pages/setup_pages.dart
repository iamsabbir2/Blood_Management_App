import 'package:blood_management_app/models/user_model.dart';
import 'package:blood_management_app/services/auth_service_firebase.dart';
import 'package:blood_management_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../services/database_service.dart';

class OnboardingPage extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onNext;
  final String buttonTitle;

  const OnboardingPage({
    super.key,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onNext,
    this.buttonTitle = 'Next',
  });

  @override
  Widget build(BuildContext context) {
    const double verticalSpacing = 20;
    const double horizontalSpacing = 20;

    return Container(
      padding: const EdgeInsets.only(
        left: horizontalSpacing,
        right: horizontalSpacing,
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: verticalSpacing),
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: verticalSpacing),
          Center(
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(height: verticalSpacing),
          ElevatedButton(
            onPressed: onNext,
            child: Text(buttonTitle),
          ),
        ],
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  bool isDonor = false;

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _checkDonorStatus() async {
    final uid = _authService.currentUser!.uid;
    bool donorStatus = await _databaseService.isDonor(uid);
    setState(() {
      isDonor = donorStatus;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkDonorStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                WelcomePage(
                  onNext: _nextPage,
                ),
                PrivacySetting(
                  onNext: _nextPage,
                ),
                const LastDonationTime()
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: isDonor ? 3 : 2,
              effect: const WormEffect(
                dotHeight: 12,
                dotWidth: 12,
                spacing: 8,
                dotColor: Colors.grey,
                activeDotColor: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  final VoidCallback onNext;

  const WelcomePage({
    super.key,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(
                    'assets/images/blood-drop_wel.png',
                  ),
                  height: 300,
                ),
                SizedBox(height: 20),
                Text(
                  'Welcome!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 20),
                Text('Thank you for signing up!'),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(200, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Let\'s go!',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class PrivacySetting extends StatefulWidget {
  final VoidCallback onNext;
  const PrivacySetting({
    super.key,
    required this.onNext,
  });

  @override
  State<PrivacySetting> createState() => _PrivacySettingState();
}

class _PrivacySettingState extends State<PrivacySetting> {
  bool _isContactHidden = false;
  bool _isPressed = false;
  final DatabaseService _databaseService = DatabaseService();
  final AuthService _authService = AuthService();
  bool isDonor = false;

  Future<void> _checkDonorStatus() async {
    final uid = _authService.currentUser!.uid;
    bool donorStatus = await _databaseService.isDonor(uid);
    setState(() {
      isDonor = donorStatus;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkDonorStatus();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/images/encryption.png'),
                  height: 300,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Privacy Settings',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Would you like to keep your contact number private?',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: _isContactHidden,
                      fillColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.red; // Fill color when selected
                          }
                          return null; // Use default fill color when not selected
                        },
                      ),
                      onChanged: (bool? value) {
                        setState(() {
                          _isContactHidden = value!;
                        });
                      },
                    ),
                    const Text(
                      'Hide Contact',
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                _isPressed = true;
              });
              await _databaseService.updateContactStatus(
                _authService.currentUser!.uid,
                _isContactHidden,
              );
              setState(() {
                _isPressed = false;
              });
              if (isDonor) {
                widget.onNext();
              } else {
                NavigationService().goBack();
                NavigationService().navigateToRoute('/');
              }
              widget.onNext();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(200, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isPressed
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Text(
                    isDonor ? 'Next' : 'Finish',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class LastDonationTime extends StatefulWidget {
  const LastDonationTime({
    super.key,
  });

  @override
  State<LastDonationTime> createState() => _LastDonationTimeState();
}

class _LastDonationTimeState extends State<LastDonationTime> {
  DateTime? _selectedDate;
  bool _isPressed = false;
  final DatabaseService _databaseService = DatabaseService();
  final AuthService _authService = AuthService();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext contxt) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage(
                    'assets/images/gear.png',
                  ),
                  height: 300,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Last Donation Time',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'What is your last donation time?',
                  textAlign: TextAlign.center,
                ),
                const Text(
                    'If you have never donated, please simply skip this.'),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: TextField(
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: InputDecoration(
                        hintText: _selectedDate == null
                            ? 'No date selected'
                            : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                _isPressed = true;
              });
              if (_selectedDate != null) {
                await _databaseService.updateLastDonationTime(
                  _authService.currentUser!.uid,
                  _selectedDate!,
                );
              }
              setState(() {
                _isPressed = false;
              });
              NavigationService().navigateToRoute('/');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(200, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isPressed
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Finish',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
