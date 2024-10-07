import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//pages
import '../widgets/chat_bubble.dart';

//models
import '../models/user_model.dart';

//services
import '../services/database_service.dart';
import '../services/auth_service.dart';

class ChatMessages extends StatelessWidget {
  final UserModel user;
  const ChatMessages({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;
    final DatabaseService _databaseService = DatabaseService();
    final AuthService _authService = AuthService();
    final chatId =
        _databaseService.getChatId(_authService.currentUser!.uid, user.uid);
    // final chatMessages = _databaseService.fetchMessages(chatId);

    return StreamBuilder(
      stream: _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final messages = snapshot.data!.docs;

        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (ctx, index) {
            final message = messages[index];
            final isMe = message['senderUid'] == _authService.currentUser!.uid;
            return ChatBubble(
              message: message['message'],
              isMe: isMe,
            );
          },
        );
      },
    );
    // return FutureBuilder(
    //   future: chatMessages,
    //   builder: (ctx, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }
    //     final messages = snapshot.data;
    //     return ListView.builder(
    //       itemCount: messages!.length,
    //       itemBuilder: (ctx, index) {
    //         final message = messages[index];
    //         return Text(message.message);
    //       },
    //     );
    //   },
    // );
  }
}
