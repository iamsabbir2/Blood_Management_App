import 'package:blood_management_app/providers/chat_stream_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//pages
import '../widgets/chat_bubble.dart';

//models
import '../models/user_model.dart';

//services
import '../services/database_service.dart';
import '../services/auth_service_firebase.dart';

class ChatMessages extends ConsumerWidget {
  final UserModel user;
  const ChatMessages({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DatabaseService databaseService = DatabaseService();
    final AuthService authService = AuthService();
    final chatId =
        databaseService.getChatId(authService.currentUser!.uid, user.uid);
    ref.read(chatStreamProvider.notifier).updateMessageStatus(chatId);
    ref.read(chatStreamProvider.notifier).fetchMessages(chatId);
    final chatStream = ref.watch(chatStreamProvider);

    return ListView.builder(
      reverse: true,
      itemCount: chatStream.length,
      itemBuilder: (ctx, index) {
        final message = chatStream[index];
        final isMe = message.senderUid == authService.currentUser!.uid;
        return ChatBubble(
          message: message.message,
          isMe: isMe,
          time: message.time,
        );
      },
    );
  }
}
