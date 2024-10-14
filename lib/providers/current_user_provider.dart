//packages
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//models
import '../models/user_model.dart';
import '../services/database_service.dart';
import '../models/data_state.dart';

class CurrentUserNotifier extends StateNotifier<DataState<UserModel>> {
  final DatabaseService _databaseService;

  CurrentUserNotifier(this._databaseService) : super(DataState.loading());

  void fetchCurrentUser(String uid) async {
    try {
      final user = await _databaseService.getUser(uid);
      state = DataState.loaded(
          UserModel.fromMap(user.data() as Map<String, dynamic>));
    } on PlatformException catch (e) {
      state = DataState.error(e.message!);
    }
  }
}

final currentUserProvider =
    StateNotifierProvider<CurrentUserNotifier, DataState<UserModel>>((ref) {
  return CurrentUserNotifier(DatabaseService());
});
