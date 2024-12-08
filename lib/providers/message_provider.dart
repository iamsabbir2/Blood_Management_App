//packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

//models
import '../models/message_model.dart';
import '../models/data_state.dart';

//services
import '../services/database_service.dart';

class MessageNotifier extends StateNotifier<DataState<List<MessageModel>>> {
  final DatabaseService _databaseService;
  MessageNotifier(this._databaseService) : super(DataState.loading());

  Future<void> addMessage(String chatId, MessageModel message) async {
    try {
      await _databaseService.addMessage(chatId, message);
    } catch (e) {
      state = DataState.error(e.toString());
    }
  }
}

final messageProvider =
    StateNotifierProvider<MessageNotifier, DataState<List<MessageModel>>>(
        (ref) {
  return MessageNotifier(DatabaseService());
});
