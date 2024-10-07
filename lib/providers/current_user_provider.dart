//packages
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
      final user = await _databaseService.fetchCurrentUser(uid);
      state = DataState.loaded(user!);
    } catch (e) {
      state = DataState.error(e.toString());
    }
  }
}

final currentUserProvider =
    StateNotifierProvider<CurrentUserNotifier, DataState<UserModel>>((ref) {
  return CurrentUserNotifier(DatabaseService());
});
