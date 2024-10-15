import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//models
import '../models/user_model.dart';
import '../models/message_model.dart';

//services
import '../services/auth_service.dart';
import '../services/database_service.dart';

//providers
import '../providers/chat_stream_provider.dart';

class NewMessage extends ConsumerStatefulWidget {
  final UserModel user;
  const NewMessage({
    super.key,
    required this.user,
  });

  @override
  ConsumerState<NewMessage> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends ConsumerState<NewMessage> {
  late AuthService _authService;
  late DatabaseService _databaseService;

  final TextEditingController _messageController = TextEditingController();
  bool _isSending = false;
  late String chatId;
  Future<void> sendNotification(String recieverId, String message) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(recieverId)
        .get();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;
    if (enteredMessage.isEmpty) {
      return;
    }
    setState(() => _isSending = true);
    FocusScope.of(context).unfocus();
    final message = MessageModel(
      messageId: '',
      message: enteredMessage,
      receiverUid: widget.user.uid,
      senderUid: _authService.currentUser!.uid,
      time: DateTime.now().toIso8601String(),
      isDelivered: false,
      isRead: false,
      isSent: false,
    );

    ref.read(chatStreamProvider.notifier).addMessage(chatId, message);
    //sent message successfully
    //update sent message

    _messageController.clear();

    setState(() {
      _isSending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _authService = AuthService();
    _databaseService = DatabaseService();
    chatId = _databaseService.getChatId(
        _authService.currentUser!.uid, widget.user.uid);
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 1,
        bottom: 14,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(
                labelText: 'Send a message...',
              ),
            ),
          ),
          _isSending
              ? const CircularProgressIndicator()
              : IconButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: _submitMessage,
                  icon: const Icon(
                    Icons.send,
                  ),
                ),
        ],
      ),
    );
  }
}
