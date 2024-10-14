import '../models/user_model.dart';

class ChatArguments {
  final UserModel user;
  final String chatId;

  ChatArguments({
    required this.user,
    required this.chatId,
  });
}
