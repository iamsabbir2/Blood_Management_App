//packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

//services
import '../services/auth_service.dart';

class AuthStateNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthService _authService;
  AuthStateNotifier(this._authService) : super(const AsyncValue.loading()) {
    _authService.authStateChanges().listen((user) {
      if (user != null) {
        state = AsyncValue.data(user);
      } else {
        state = const AsyncValue.data(null);
      }
    });
  }

  void setUser(User? user) {
    state = AsyncValue.data(user);
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _authService.signInWithEmailAndPassword(email, password);
      setUser(_authService.currentUser);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<UserCredential?> signUp(String email, String password) async {
    try {
      return await _authService.signUpWithEmailAndPassword(email, password);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
    return null;
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      setUser(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});
final authProvider =
    StateNotifierProvider<AuthStateNotifier, AsyncValue<User?>>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthStateNotifier(authService);
});
