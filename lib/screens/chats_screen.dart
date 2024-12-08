// ignore_for_file: prefer_final_fields

import 'dart:async';

import 'package:blood_management_app/services/auth_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
//models
import '../models/chat_model.dart';
import '../models/data_state.dart';
//services
import '../services/navigation_service.dart';

//providers
import '../providers/chat_provider.dart';

//uitility functions
import '../utility_functions/chat_times.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  const ChatsScreen({
    super.key,
  });

  @override
  ConsumerState<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  // late List<ChatModel> chatUsers = [];
  //ignore: , prefer_final_fields
  late TextEditingController _searchController = TextEditingController();
  StreamSubscription<List<ConnectivityResult>>? subscription;
  List<ConnectivityResult>? connectivityResult;
  bool _isConnected = true;
  late AuthService _authService;
  late DataState<List<ChatModel>> chatState;
  String searchQuery = '';
  @override
  initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      setState(() {
        connectivityResult = result;

        if (connectivityResult!.contains(ConnectivityResult.none)) {
          _isConnected = false;
          Logger().i('No internet connection');
        } else {
          _isConnected = true;
          Logger().i('Internet connection available');
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    subscription!.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _authService = AuthService();
    ref.read(chatsProvider.notifier).fetchChats();
    chatState = ref.watch(chatsProvider);

    return kIsWeb
        ? Row(
            children: [
              Expanded(
                child: _buildChatList(),
              ),
              Expanded(
                  child: Container(
                color: Colors.red,
              )),
            ],
          )
        : _buildChatList();
  }

  Widget _buildChatList() {
    final filteredChatUsers = chatState.data?.where((chat) {
          return chat.otherUser.name.toLowerCase().contains(searchQuery);
        }).toList() ??
        [];
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
            onEditingComplete: () {
              setState(() {
                searchQuery = _searchController.text;
              });
              FocusScope.of(context).unfocus();
            },
          ),
        ),
        if (!_isConnected)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              'Connecting...',
              style: TextStyle(color: Colors.red),
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
                  : filteredChatUsers.isEmpty
                      ? const Center(
                          child: Text('No chats found!'),
                        )
                      : ListView.builder(
                          itemCount: filteredChatUsers.length,
                          itemBuilder: (context, index) {
                            final chat = filteredChatUsers[index];

                            return ListTile(
                              leading: Stack(
                                children: [
                                  const CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                                  ),
                                  if (chat.otherUser.isOnline!)
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        height: 10,
                                        width: 10,
                                        decoration: const BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    )
                                ],
                              ),
                              horizontalTitleGap: 8,
                              title: Text(chat.otherUser.name),
                              subtitle: Row(
                                children: [
                                  if (chat.messages.senderUid ==
                                      _authService.currentUser!.uid) ...[
                                    if (chat.messages.isRead)
                                      const Icon(
                                        Icons.done_all,
                                        size: 16,
                                        color: Colors.blueAccent,
                                      )
                                    else if (chat.messages.isDelivered)
                                      const Icon(
                                        Icons.done_all,
                                        size: 16,
                                        color: Colors.grey,
                                      )
                                    else if (chat.messages.isSent)
                                      const Icon(
                                        Icons.done,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                    const SizedBox(width: 4),
                                  ],
                                  Expanded(
                                    child: Text(
                                      chat.messages.message,
                                      style: TextStyle(
                                        fontWeight: chat.messages.senderUid !=
                                                _authService.currentUser!.uid
                                            ? chat.messages.isRead
                                                ? FontWeight.normal
                                                : FontWeight.bold
                                            : FontWeight.normal,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Text(
                                ChatTime.getTimes(chat.messages.time),
                                style: TextStyle(
                                  fontWeight: chat.messages.senderUid !=
                                          _authService.currentUser!.uid
                                      ? chat.messages.isRead
                                          ? FontWeight.normal
                                          : FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              onTap: () {
                                NavigationService().navigateToRoute('/chat',
                                    arguments: chat.otherUser);
                              },
                            );
                          },
                        ),
        ),
      ],
    );
  }
}
