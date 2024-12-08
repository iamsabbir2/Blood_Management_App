import 'package:blood_management_app/widgets/chat_messages.dart';
import 'package:flutter/material.dart';
import '../widgets/new_messages.dart';
import 'package:url_launcher/url_launcher.dart';
//models
import '../models/user_model.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UserModel;
    Future<void> makePhoneCall(String phoneNumber) async {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      await launchUrl(launchUri);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          args.name,
        ),
        actions: [
          if (!args.isContactHidden)
            IconButton(
              icon: const Icon(Icons.phone),
              onPressed: () async {
                await makePhoneCall(args.contact);
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
