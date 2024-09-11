import 'package:blood_management_app/screens/main_screen.dart';
import 'package:blood_management_app/screens/profile_screen.dart';
import 'package:blood_management_app/widgets/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectPageIndex = index;
    });
  }

  static const List<BottomNavigationBarItem> _navigationItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  ];
  var activePageTitle = 'Blood Management App';
  Widget activePage = BmaScreen();
  @override
  Widget build(BuildContext context) {
    if (_selectPageIndex == 1) {
      activePageTitle = 'Profile';
      activePage = ProfileScreen();
    }

    if (_selectPageIndex == 0) {
      activePageTitle = 'Blood Management App';
      activePage = BmaScreen();
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.error,
        title: Text(
          activePageTitle,
        ),
        actions: [
          if (_selectPageIndex == 0)
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
              },
            ),
        ],
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          _selectPage(index);
        },
        currentIndex: _selectPageIndex,
        items: _navigationItems,
      ),
    );
  }
}
