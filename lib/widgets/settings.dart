import 'package:blood_management_app/screens/profile.dart';
import 'package:blood_management_app/widgets/account.dart';

import 'package:blood_management_app/widgets/notifications.dart';
import 'package:blood_management_app/widgets/privacy.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() {
    return _SettingsState();
  }
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      //backgroundColor:

      body: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(),
            title: Text(
              'Sabbir Hasan',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) {
                    return const Profile();
                  },
                ),
              );
            },
            subtitle: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '+8801799893419',
                ),
                Text(
                  'AB+',
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.key),
            title: const Text('Account'),
            subtitle: const Text('Security Notification,change number'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) {
                    return const Account();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Privacy'),
            subtitle: const Text('Block contacts, dissappearing message'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) {
                    return const Privacy();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.reddit_outlined),
            title: const Text('Avatar'),
            subtitle: const Text('Create, edit, profile photo'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Chats'),
            subtitle: const Text('Theme, wallpaper and chat history'),
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (ctx) {
              //       return const Chats();
              //     },
              //   ),
              // );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_none),
            title: const Text('Notifications'),
            subtitle: const Text('Message & call tune'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) {
                    return const Notifications();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.sync),
            title: const Text('Storage and data'),
            subtitle: const Text('Security Notification,change number'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('App language'),
            subtitle: const Text('English (device\'s language)'),
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return BottomSheet(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        onClosing: () {},
                        showDragHandle: true,
                        constraints: const BoxConstraints(
                          maxHeight: 300,
                        ),
                        builder: (ctxx) {
                          return const Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  label: Text('Name :'),
                                ),
                              )
                            ],
                          );
                        });
                  });
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help'),
            subtitle: const Text('Help center, contact us, privacy policy'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.security_update_good),
            title: const Text('App updates'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
