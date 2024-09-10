import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme.copyWith(
              color: Colors.white,
            ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  8,
                ),
                border: Border.all(color: Colors.red)),
            width: 40,
            height: 250,
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(
              'Name',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            subtitle: const Text('Sabbir Hasan'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (ctx) => SimpleDialog(
                        title: const Text(
                          'Name',
                          style: TextStyle(color: Colors.white),
                        ),
                        children: [
                          TextFormField(
                            decoration:
                                const InputDecoration(label: Text('Name')),
                          ),
                        ],
                      ));
            },
            trailing: const Icon(Icons.edit),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(
              'Name',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            subtitle: const Text('Sabbir Hasan'),
            onTap: () {},
            trailing: const Icon(Icons.edit),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(
              'Name',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            subtitle: const Text('Sabbir Hasan'),
            onTap: () {},
            trailing: const Icon(Icons.edit),
          ),
        ],
      ),
    );
  }
}
