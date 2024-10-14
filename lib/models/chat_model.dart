//models
import 'user_model.dart';
import 'message_model.dart';

class ChatModel {
  final String uid;
  final UserModel otherUser;
  final MessageModel messages;

  ChatModel({
    required this.uid,
    required this.otherUser,
    required this.messages,
  });

  factory ChatModel.fromMap(Map<String, dynamic> data) {
    return ChatModel(
      uid: data['uid'],
      otherUser: UserModel.fromMap(data['otherUser']),
      messages: MessageModel.fromJson(data['messages']),
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['uid'] = uid;
    data['otherUser'] = otherUser;
    data['messages'] = messages;
    return data;
  }
}
