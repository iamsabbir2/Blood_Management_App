import 'package:blood_management_app/screens/main_screen.dart';
import 'package:blood_management_app/screens/my_requests.dart';
import 'package:blood_management_app/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:blood_management_app/widgets/chats.dart';

//services
import '../services/navigation_service.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int selectPageIndex = 0;
  final List<Widget> _pages = [
    const BmaScreen(),
    const MyRequests(),
    const ChatsScreen(),
    const ProfileScreen(),
  ];

  void _selectPage(int index) {
    setState(() {
      selectPageIndex = index;
    });
  }

  List<BottomNavigationBarItem> get _navigationItems {
    return [
      BottomNavigationBarItem(
          icon: Icon(
            selectPageIndex == 0 ? Icons.home_filled : Icons.home,
          ),
          label: 'Home'),
      BottomNavigationBarItem(
          icon: Icon(selectPageIndex == 1
              ? Icons.request_page
              : Icons.request_page_outlined),
          label: 'MyRequests'),
      BottomNavigationBarItem(
          icon: Icon(selectPageIndex == 2 ? Icons.chat : Icons.chat_outlined),
          label: 'Chats'),
      BottomNavigationBarItem(
          icon:
              Icon(selectPageIndex == 3 ? Icons.person : Icons.person_outline),
          label: 'Profile'),
    ];
  }

  var activePageTitle = 'Blood Management App';
  Widget activePage = const BmaScreen();
  @override
  Widget build(BuildContext context) {
    if (selectPageIndex == 3) {
      activePageTitle = 'Profile';
      activePage = const ProfileScreen();
    }
    if (selectPageIndex == 2) {
      activePageTitle = 'Chats';
      activePage = const ChatsScreen();
    }
    if (selectPageIndex == 1) {
      activePageTitle = 'My Requests';
      activePage = const MyRequests();
    }

    if (selectPageIndex == 0) {
      activePageTitle = 'Blood Management App';
      activePage = const BmaScreen();
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          activePageTitle,
        ),
        actions: [
          if (selectPageIndex == 0)
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  if (selectPageIndex == 0)
                    const PopupMenuItem(
                      value: 1,
                      child: Text('Logout'),
                    )
                ];
              },
              onSelected: (value) async {
                if (value == 1) {
                  await FirebaseAuth.instance.signOut();
                  // NavigationService().navigateToRoute('/login');
                }
              },
            ),
          if (selectPageIndex == 2)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors
                    .white, // You can change the background color as needed
                child: IconButton(
                  onPressed: () {
                    NavigationService().navigateToRoute('/new_message_screen');
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      body: _pages[selectPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 30.0,
        onTap: (index) {
          _selectPage(index);
        },
        currentIndex: selectPageIndex,
        items: _navigationItems,
      ),
    );
  }
}
