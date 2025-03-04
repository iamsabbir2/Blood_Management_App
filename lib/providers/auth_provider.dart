import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

class AuthState {
  final String? token;
  final String? error;

  AuthState._({this.token, this.error});

  factory AuthState.initial() => AuthState._();
  factory AuthState.authenticated(String token) => AuthState._(token: token);
  factory AuthState.unauthenticated() => AuthState._();
  factory AuthState.error(String error) => AuthState._(error: error);
}

class AuthNotifier extends StateNotifier<AsyncValue<AuthState>> {
  AuthNotifier() : super(const AsyncValue.loading()) {
    _checkAuthStatus();
  }

  final AuthService _authService = AuthService();

  Future<void> login(String email, String password) async {
    try {
      state = const AsyncValue.loading();
      await _authService.logIn(email, password);
      final token = await _authService.getToken();

      if (token != null) {
        state = AsyncValue.data(AuthState.authenticated(token));
      } else {
        state = AsyncValue.error('token is null', StackTrace.current);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e.toString(), stackTrace);
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = AsyncValue.data(AuthState.unauthenticated());
  }

  Future<void> _checkAuthStatus() async {
    final token = await _authService.getToken();
    if (token != null) {
      state = AsyncValue.data(AuthState.authenticated(token));
    } else {
      state = AsyncValue.data(AuthState.unauthenticated());
    }
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<AuthState>>((ref) {
  return AuthNotifier();
});
