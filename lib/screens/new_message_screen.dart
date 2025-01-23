//package
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//providers
import '../providers/user_provider.dart';

//models
import '../models/user_model.dart';
import '../models/data_state.dart';

//services
import '../services/auth_service_firebase.dart';
import '../services/navigation_service.dart';
import '../services/database_service.dart';

class NewMessageScreen extends ConsumerStatefulWidget {
  const NewMessageScreen({super.key});

  @override
  ConsumerState<NewMessageScreen> createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends ConsumerState<NewMessageScreen> {
  late DataState<List<UserModel>> donors;
  late List<UserModel> chatUsers;
  late DatabaseService _databaseService;
  late AuthService _authService;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    donors = ref.watch(userProvider);
    chatUsers = donors.data != null ? donors.data! : [];
    final filteredChatUsers = chatUsers.where((user) {
      return user.uid != AuthService().currentUser!.uid && user.isDonor == true;
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Messages'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error occured'),
            );
          }
          final users = snapshot.data!.docs;
          final filteredUser = users.where((user) {
            return user['uid'] != AuthService().currentUser!.uid &&
                user['isDonor'] == true &&
                user['name'].toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

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
                      _searchQuery = _searchController.text;
                    });
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
              Expanded(
                child: filteredUser.isEmpty
                    ? const Center(
                        child: Text('No user found!'),
                      )
                    : ListView.builder(
                        itemCount: filteredUser.length,
                        itemBuilder: (context, index) {
                          final user = filteredUser[index];
                          return ListTile(
                            title: Text(user['name']),
                            subtitle: Text(user['bloodGroup']),
                            onTap: () {
                              // Handle user tap
                              NavigationService().navigateToRoute(
                                '/chat',
                                arguments: UserModel.fromMap(user.data()),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      // body: donors.isLoading
      //     ? const Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     : donors.errorMessage != null
      //         ? const Center(
      //             child: Text('An error occured'),
      //           )
      //         : filteredChatUsers.isEmpty
      //             ? const Center(
      //                 child: Text('No users found'),
      //               )
      //             : Column(
      //                 children: [
      //                   Padding(
      //                     padding: const EdgeInsets.all(8.0),
      //                     child: TextField(
      //                       controller: _searchController,
      //                       decoration: InputDecoration(
      //                         hintText: 'Search',
      //                         prefixIcon: const Icon(Icons.search),
      //                         border: OutlineInputBorder(
      //                           borderRadius: BorderRadius.circular(10),
      //                         ),
      //                       ),
      //                       onChanged: (value) {},
      //                     ),
      //                   ),
      //                   Expanded(
      //                     child: ListView.builder(
      //                       itemCount: filteredChatUsers.length,
      //                       itemBuilder: (context, index) {
      //                         final user = filteredChatUsers[index];
      //                         return ListTile(
      //                           title: Text(user.name),
      //                           subtitle: Text(user.bloodGroup),
      //                           onTap: () {
      //                             // Handle user tap
      //                             NavigationService().navigateToRoute(
      //                               '/chat',
      //                               arguments: user,
      //                             );
      //                           },
      //                         );
      //                       },
      //                     ),
      //                   ),
      //                 ],
      //               ),
    );
  }
}
