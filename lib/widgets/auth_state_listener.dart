//packages
import 'package:blood_management_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//providers
import '../authentication/email_verification.dart';
import '../providers/auth_provider.dart';

//widges
import 'tabs.dart';
import '../screens/login.dart';

class AuthStateListener extends ConsumerWidget {
  const AuthStateListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    return authState.when(
      data: (user) {
        if (user != null) {
          if (!user.emailVerified) {
            return const EmailVerificationPage();
          }
          return const TabsScreen();
        }
        return const Login();
      },
      error: (error, stackTrace) {
        return Scaffold(
          body: Center(
            child: AlertDialog(
              title: const Text('Error'),
              content: Text(error.toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    ref.read(authProvider.notifier).signOut();
                  },
                  child: const Text('Ok'),
                )
              ],
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
