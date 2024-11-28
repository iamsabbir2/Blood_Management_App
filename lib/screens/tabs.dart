import 'package:blood_management_app/screens/home_screen.dart';
import 'package:blood_management_app/screens/my_requests.dart';
import 'package:blood_management_app/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
    const HomeScreen(),
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
              ? Icons.bloodtype
              : Icons.bloodtype_outlined),
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
  Widget activePage = const HomeScreen();
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
      activePage = const HomeScreen();
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          activePageTitle,
        ),
        flexibleSpace: kIsWeb
            ? Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        NavigationService().navigateToRoute('/donors');
                      },
                      label: const Text(
                        'Find Donors',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      label: const Text(
                        'Blood Request',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      icon: const Icon(
                        Icons.bloodtype,
                        color: Colors.white,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      label: const Text(
                        'Responses',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      icon: const Icon(
                        Icons.reply,
                        color: Colors.white,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      label: const Text(
                        'Donations',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      icon: const Icon(
                        Icons.volunteer_activism,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            : null,
        actions: [
          if (selectPageIndex == 0)
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  if (selectPageIndex == 0)
                    const PopupMenuItem(
                      value: 1,
                      child: Text('Logout'),
                    ),
                  const PopupMenuItem(
                    value: 2,
                    child: Text(
                      'Settings',
                    ),
                  ),
                ];
              },
              onSelected: (value) async {
                if (value == 1) {
                  await FirebaseAuth.instance.signOut();
                  await Future.delayed(const Duration(seconds: 2));
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
      drawer: const Drawer(
        child: Text('Drawer'),
      ),
      body: Row(
        children: [
          if (kIsWeb)
            NavigationRail(
              selectedIndex: selectPageIndex,
              onDestinationSelected: (index) {
                _selectPage(index);
              },
              labelType: NavigationRailLabelType.all,
              destinations: _navigationItems
                  .map(
                    (e) => NavigationRailDestination(
                      icon: e.icon,
                      label: Text(e.label!),
                    ),
                  )
                  .toList(),
            ),
          Expanded(child: _pages[selectPageIndex]),
        ],
      ),
      bottomNavigationBar: kIsWeb
          ? null
          : BottomNavigationBar(
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
