//packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

//models
import '../models/message_model.dart';

//services
import '../services/database_service.dart';

class ChatStreamNotifier extends StateNotifier<List<MessageModel>> {
  final DatabaseService _databaseService;
  ChatStreamNotifier(this._databaseService) : super([]);

  void fetchMessages(String chatId) async {
    final messages = await _databaseService.fetchMessage(chatId);
    state = messages;
  }

  void addMessage(String chatId, MessageModel message) async {
    await _databaseService.addMessage(chatId, message);
    fetchMessages(chatId);
  }

  void updateMessageStatus(String chatId) async {
    await _databaseService.updateMessageStatus(chatId);
  }
}

final chatStreamProvider =
    StateNotifierProvider<ChatStreamNotifier, List<MessageModel>>((ref) {
  return ChatStreamNotifier(DatabaseService());
});
