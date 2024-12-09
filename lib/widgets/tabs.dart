import 'package:blood_management_app/providers/auth_provider.dart';
import 'package:blood_management_app/screens/home_screen.dart';
import 'package:blood_management_app/screens/my_requests.dart';
import 'package:blood_management_app/screens/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blood_management_app/screens/chats_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//services
import '../authentication/email_verification.dart';
import '../services/navigation_service.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int selectPageIndex = 0;
  final List<Widget> _pages = [
    const HomeScreen(),
    const MyRequests(),
    const ChatsScreen(),
    const Settings(),
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
          icon: Icon(
              selectPageIndex == 3 ? Icons.settings : Icons.settings_outlined),
          label: 'Settings'),
    ];
  }

  var activePageTitle = 'Blood Management App';
  Widget activePage = const HomeScreen();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (selectPageIndex == 3) {
      activePageTitle = 'Settings';
      activePage = const Settings();
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
        automaticallyImplyLeading: !kIsWeb
            ? false
            : width > 1000
                ? false
                : true,
        title: Text(
          activePageTitle,
        ),
        flexibleSpace: kIsWeb
            ? width > 1000
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
                          onPressed: () {
                            NavigationService().navigateToRoute('/request');
                          },
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
                          onPressed: () {
                            NavigationService().navigateToRoute('/response');
                          },
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
                          onPressed: () {
                            NavigationService().navigateToRoute('/donations');
                          },
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
                : null
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
                ];
              },
              onSelected: (value) async {
                if (value == 1) {
                  await ref.read(authProvider.notifier).signOut();
                  await Future.delayed(const Duration(seconds: 3));
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
      drawer: kIsWeb
          ? Drawer(
              child: ListView(
                children: <Widget>[
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Text('Menu'),
                  ),
                  ListTile(
                    title: const Text('Find Donor'),
                    leading: const Icon(Icons.search),
                    onTap: () {
                      NavigationService().goBack();
                      NavigationService().navigateToRoute('/donors');
                    },
                  ),
                  ListTile(
                    title: const Text('Blood Request'),
                    leading: const Icon(Icons.bloodtype),
                    onTap: () {
                      NavigationService().goBack();
                      NavigationService().navigateToRoute('/request');
                    },
                  ),
                  ListTile(
                    title: const Text('Responses'),
                    leading: const Icon(Icons.reply),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Donations'),
                    leading: const Icon(Icons.volunteer_activism),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            )
          : null,
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
