import 'package:blood_management_app/screens/main_screen.dart';
import 'package:blood_management_app/screens/my_requests.dart';
import 'package:blood_management_app/screens/profile_screen.dart';
import 'package:blood_management_app/widgets/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blood_management_app/screens/chats.dart';

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

  List<BottomNavigationBarItem> get _navigationItems {
    return [
      BottomNavigationBarItem(
          icon: Icon(
            _selectPageIndex == 0 ? Icons.home_filled : Icons.home,
          ),
          label: 'Home'),
      BottomNavigationBarItem(
          icon: Icon(_selectPageIndex == 1
              ? Icons.request_page
              : Icons.request_page_outlined),
          label: 'MyRequests'),
      BottomNavigationBarItem(
          icon: Icon(_selectPageIndex == 2 ? Icons.chat : Icons.chat_outlined),
          label: 'Chats'),
      BottomNavigationBarItem(
          icon:
              Icon(_selectPageIndex == 3 ? Icons.person : Icons.person_outline),
          label: 'Profile'),
    ];
  }

  var activePageTitle = 'Blood Management App';
  Widget activePage = BmaScreen();
  @override
  Widget build(BuildContext context) {
    if (_selectPageIndex == 3) {
      activePageTitle = 'Profile';
      activePage = ProfileScreen();
    }
    if (_selectPageIndex == 2) {
      activePageTitle = 'Chats';
      activePage = ChatsScreen();
    }
    if (_selectPageIndex == 1) {
      activePageTitle = 'My Requests';
      activePage = MyRequests();
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
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                if (_selectPageIndex == 0)
                  PopupMenuItem(
                    child: const Text('Logout'),
                    value: 1,
                  )
              ];
            },
            onSelected: (value) async {
              if (value == 1) {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 30.0,
        onTap: (index) {
          _selectPage(index);
        },
        currentIndex: _selectPageIndex,
        items: _navigationItems,
      ),
    );
  }
}
