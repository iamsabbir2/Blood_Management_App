import 'package:blood_management_app/widgets/chat_messages.dart';
import 'package:flutter/material.dart';
import '../widgets/new_messages.dart';

//models
import '../models/user_model.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UserModel;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          args.name,
        ),
        actions: [
          if (!args.isContactHidden)
            IconButton(
              icon: const Icon(Icons.phone),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Call'),
                  ),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Info'),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessages(
              user: args,
            ),
          ),
          NewMessage(
            user: args,
          ),
        ],
      ),
    );
  }
}
