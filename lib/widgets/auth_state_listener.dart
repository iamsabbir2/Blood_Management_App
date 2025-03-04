//packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//providers
import '../providers/auth_provider.dart';

//widges
import '../screens/login.dart';
import '../screens/random_tab.dart';

class AuthStateListener extends ConsumerWidget {
  const AuthStateListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    return authState.when(
      data: (authState) {
        if (authState.token != null) {
          return const RandomTab();
        }
        return const Login();
      },
      error: (error, stackTrace) {
        return Scaffold(
          body: Center(
            child: AlertDialog(
              title: const Text('Error'),
              content: Text(error.toString()),
            ),
          ),
        );
      },
      loading: () {
        return const Scaffold(
          body: Center(
            child: Text('Loading...'),
          ),
        );
      },
    );
  }
}
