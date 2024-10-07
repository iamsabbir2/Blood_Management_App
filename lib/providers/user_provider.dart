import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_management_app/models/user_model.dart';

//services
import '../services/database_service.dart';

//models
import '../models/data_state.dart';

class UserNotifier extends StateNotifier<DataState<List<UserModel>>> {
  final DatabaseService _databaseService;

  UserNotifier(this._databaseService) : super(DataState.loading()) {
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final users = await _databaseService.fetchUsers();
      state = DataState.loaded(users);
    } catch (e) {
      state = DataState.error(e.toString());
    }
  }

  Future<void> addUser(UserModel user) async {
    try {
      await _databaseService.addUser(user);
      fetchUsers();
    } catch (e) {
      state = DataState.error(e.toString());
    }
  }

  void updateIsGoingToDonate(String uid, bool isGoingToDonate) async {
    try {
      await _databaseService.updateIsGoingToDonate(uid, isGoingToDonate);
      fetchUsers();
    } catch (e) {
      state = DataState.error(e.toString());
    }
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, DataState<List<UserModel>>>((ref) {
  return UserNotifier(DatabaseService());
});
