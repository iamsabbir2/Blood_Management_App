import 'package:blood_management_app/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//models
import '../models/chat_model.dart';
import '../models/user_model.dart';
//services
import '../services/navigation_service.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  const ChatsScreen({
    super.key,
  });

  @override
  ConsumerState<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  late List<ChatModel> chatUsers = [];
  late FirebaseFirestore _firestore;
  late final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  late AuthService _authService;

  @override
  Widget build(BuildContext context) {
    _firestore = FirebaseFirestore.instance;
    _authService = AuthService();

    return _buildUI();
  }

  Widget _buildUI() {
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
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('chats')
                .where('particpants',
                    arrayContains: _authService.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text('An error occurred'),
                );
              }

              final chatDocs = snapshot.data!.docs;
              return ListView.builder(
                itemCount: chatDocs.length,
                itemBuilder: (context, index) {
                  final chatData =
                      chatDocs[index].data() as Map<String, dynamic>;
                  final participants = chatData['particpants'] as List<dynamic>;
                  final otherUserUid = participants.firstWhere(
                      (uid) => uid != _authService.currentUser!.uid);

                  return FutureBuilder<DocumentSnapshot>(
                    future:
                        _firestore.collection('users').doc(otherUserUid).get(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const ListTile(
                          title: Text('Loading...'),
                        );
                      }
                      if (userSnapshot.hasError) {
                        return const ListTile(
                          title: Text('Error loading user'),
                        );
                      }

                      final userData =
                          userSnapshot.data!.data() as Map<String, dynamic>;
                      final userName = userData['name'] as String;

                      return StreamBuilder(
                          stream: _firestore
                              .collection('chats')
                              .doc(chatDocs[index].id)
                              .collection('messages')
                              .orderBy('time', descending: true)
                              .limit(1)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return ListTile(
                                title: Text(userName),
                                subtitle: const Text('Loading...'),
                              );
                            }
                            if (snapshot.hasError) {
                              return ListTile(
                                title: Text(userName),
                                subtitle: const Text('Error loading message'),
                              );
                            }
                            if (snapshot.data!.docs.isEmpty) {
                              return ListTile(
                                title: Text(userName),
                                subtitle: const Text('No messages'),
                              );
                            }
                            final lastMessageDocs = snapshot.data!.docs;
                            final lastMessage = lastMessageDocs.isNotEmpty
                                ? lastMessageDocs.first['message'] as String
                                : 'No messages';
                            return ListTile(
                              title: Text(userName),
                              subtitle: Text(lastMessage),
                              onTap: () {
                                NavigationService().navigateToRoute(
                                  '/chat',
                                  arguments: UserModel.fromMap(userData),
                                );
                              },
                            );
                          });
                      // return ListTile(
                      //   title: Text(userName),
                      //   subtitle: const Text(
                      //       'Last message...'), // You can customize this to show the last message
                      //   onTap: () {
                      //     NavigationService().navigateToRoute(
                      //       '/chat',
                      //       arguments: UserModel.fromMap(userData),
                      //     );
                      //   },
                      // );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
