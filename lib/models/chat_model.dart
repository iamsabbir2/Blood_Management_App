//models
import 'user_model.dart';
import 'message_model.dart';

class ChatModel {
  String? uid;
  UserModel? otherUser;
  List<MessageModel>? messages;

  ChatModel({
    this.uid,
    this.otherUser,
    this.messages,
  });
}
