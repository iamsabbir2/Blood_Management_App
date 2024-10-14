import 'package:blood_management_app/providers/user_provider.dart';
import 'package:blood_management_app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//models
import '../models/chat_model.dart';
import '../models/user_model.dart';
import '../models/data_state.dart';
//services
import '../services/navigation_service.dart';

//providers
import '../providers/chat_provider.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  const ChatsScreen({
    super.key,
  });

  @override
  ConsumerState<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  // late List<ChatModel> chatUsers = [];
  late FirebaseFirestore _firestore;
  late final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  late AuthService _authService;
  late DataState<List<ChatModel>> chatState;

  @override
  Widget build(BuildContext context) {
    _firestore = FirebaseFirestore.instance;
    _authService = AuthService();
    ref.read(chatsProvider.notifier).fetchChats();
    chatState = ref.watch(chatsProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {},
          ),
        ),
        Expanded(
          child: chatState.isLoading
              ? const Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    ),
                  ),
                )
              : chatState.errorMessage != null
                  ? Center(
                      child: Text(chatState.errorMessage!),
                    )
                  : ListView.builder(
                      itemCount: chatState.data!.length,
                      itemBuilder: (context, index) {
                        final chat = chatState.data![index];
                        return ListTile(
                            title: Text(chat.otherUser!.name),
                            subtitle: Text(chat.messages!.message),
                            trailing: Text(chat.messages!.time),
                            onTap: () {
                              NavigationService().navigateToRoute('/chat',
                                  arguments: chat.otherUser);
                            });
                      },
                    ),
        ),
      ],
    );
  }
}
