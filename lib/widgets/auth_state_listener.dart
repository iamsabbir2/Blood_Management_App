//packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//providers
import '../providers/auth_provider.dart';

//widges
import '../screens/tabs.dart';
import '../widgets/login.dart';

class AuthStateListener extends ConsumerWidget {
  const AuthStateListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return authState.when(
      data: (user) {
        if (user != null) {
          return const TabsScreen();
        }
        return const Login();
      },
      error: (error, stackTrace) {
        return Scaffold(
          body: Center(
            child: Text('An error occurred :$error'),
          ),
        );
      },
      loading: () {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
