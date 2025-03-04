import 'package:blood_management_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RandomTab extends ConsumerWidget {
  const RandomTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test'),
        actions: [
          MenuBar(
            children: [
              IconButton(
                onPressed: () async {
                  bool? confirmLogout = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('Logout'),
                          ),
                        ],
                      );
                    },
                  );
                  if (confirmLogout == true) {
                    // Perform logout action
                    await ref.read(authProvider.notifier).logout();
                  }
                },
                icon: const Icon(Icons.three_g_mobiledata),
              )
            ],
          )
        ],
      ),
      body: const Center(
        child: Text('Hello'),
      ),
    );
  }
}
