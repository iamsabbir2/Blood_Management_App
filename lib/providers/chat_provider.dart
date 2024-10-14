import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

//models
import '../models/chat_model.dart';
import '../models/data_state.dart';
//services
import '../services/database_service.dart';
import '../services/auth_service.dart';

class ChatsNotifier extends StateNotifier<DataState<List<ChatModel>>> {
  final DatabaseService _databaseService;
  final AuthService _authService;
  ChatsNotifier(this._databaseService, this._authService)
      : super(DataState.loading()) {
    fetchChats();
  }

  void fetchChats() async {
    final chats =
        await _databaseService.fetchChats(_authService.currentUser!.uid);
    state = DataState.loaded(chats);
  }
}

final chatsProvider =
    StateNotifierProvider<ChatsNotifier, DataState<List<ChatModel>>>((ref) {
  return ChatsNotifier(DatabaseService(), AuthService());
});
