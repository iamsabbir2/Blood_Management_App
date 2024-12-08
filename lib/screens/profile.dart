import 'package:blood_management_app/services/database_service.dart';
import 'package:blood_management_app/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/data_state.dart';
import '../models/user_model.dart';
import '../providers/current_user_provider.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends ConsumerState<Profile> {
  late DataState<UserModel> _currentUser;
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    _currentUser = ref.watch(currentUserProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme.copyWith(
              color: Colors.white,
            ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(32.0),
            child: CircleAvatar(
              radius: 100,
              backgroundImage: NetworkImage(
                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: const Icon(
                Icons.person,
                size: 20,
              ),
              title: const Text(
                'Name',
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              subtitle: _currentUser.data != null
                  ? Text(_currentUser.data!.name)
                  : const Text('fetching...'),
              onTap: () {
                showAdaptiveDialog(
                    context: context,
                    builder: (ctx) {
                      TextEditingController nameController =
                          TextEditingController();
                      nameController.text = _currentUser.data?.name ?? '';
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        title: const Text('Name'),
                        content: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Enter Your Name',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                            },
                            child: const Text('Cancel'),
                          ),
                          CustomElevatedButton(
                            isLoading: false,
                            onPressed: () {
                              Navigator.pop(ctx);
                            },
                            title: 'Save',
                            width: 30,
                            height: 40,
                            fontSize: 16,
                          ),
                        ],
                      );
                    });
              },
              trailing: const Icon(
                Icons.edit,
                color: Colors.red,
                size: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: const Icon(
                Icons.phone,
                size: 20,
              ),
              title: const Text(
                'Phone',
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              subtitle: _currentUser.data != null
                  ? Text(_currentUser.data!.contact)
                  : const Text('fetching...'),
              onTap: () {
                showAdaptiveDialog(
                    context: context,
                    builder: (context) {
                      TextEditingController phoneController =
                          TextEditingController();
                      phoneController.text = _currentUser.data?.contact ?? '';
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        title: const Text('Phone'),
                        content: TextField(
                          controller: phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Enter Your Phone Number',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          CustomElevatedButton(
                            isLoading: false,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            title: 'Save',
                            width: 30,
                            height: 40,
                            fontSize: 16,
                          ),
                        ],
                      );
                    });
              },
              trailing: const Icon(
                Icons.edit,
                color: Colors.red,
                size: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: const Icon(
                Icons.email,
                size: 20,
              ),
              title: const Text(
                'Email',
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              subtitle: _currentUser.data != null
                  ? Text(_currentUser.data!.email)
                  : const Text('fetching...'),
            ),
          ),
        ],
      ),
    );
  }
}
