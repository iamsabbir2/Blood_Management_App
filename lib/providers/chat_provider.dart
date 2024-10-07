import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

//models
import '../models/chat_model.dart';
import '../models/chat_message.dart';
import '../models/user_model.dart';
import '../models/message_model.dart';

//services
import '../services/database_service.dart';
import '../services/auth_service.dart';

class ChatProvider extends StateNotifier<List<ChatModel>> {
  final DatabaseService _databaseService = DatabaseService();
  List<ChatModel>? _chats;
  final AuthService _authService = AuthService();
  late StreamSubscription _chatSubscription;

  ChatProvider() : super([]) {}

  void dispose() {
    _chatSubscription.cancel();
    super.dispose();
  }
}

final chatProvider =
    StateNotifierProvider<ChatProvider, List<ChatModel>>((ref) {
  return ChatProvider();
});
