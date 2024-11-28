import 'package:blood_management_app/models/data_state.dart';
import 'package:blood_management_app/models/user_model.dart';
import 'package:flutter/material.dart';
import '../providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late DataState<UserModel> _currentUser;
  bool _isLoading = false;
  bool _isSubmitting = false;

  void _showEditDialog(BuildContext context, String title, String currentValue,
      Function(String) onSaved) {
    TextEditingController _controller =
        TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit ${title}'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter your ${title}',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            Stack(
              children: [
                TextButton(
                  onPressed: _isSubmitting
                      ? null
                      : () async {
                          // update name
                          setState(() {
                            _isSubmitting = true;
                          });
                          await onSaved(_controller.text);

                          Navigator.of(context).pop();
                        },
                  child: const Text('Save'),
                ),
                if (_isSubmitting) const CircularProgressIndicator(),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _currentUser = ref.watch(currentUserProvider);
    return _currentUser.isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : _currentUser.errorMessage != null
            ? Center(
                child: Text(_currentUser.errorMessage!),
              )
            : _isLoading
                ? const CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(
                                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                            ),
                            title: Text(_currentUser.data!.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_currentUser.data!.email),
                                Text(_currentUser.data!.contact)
                              ],
                            ),
                            trailing: Text(
                              _currentUser.data!.bloodGroup,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(
                                  23,
                                  23,
                                  23,
                                  0.4,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Card(
                              child: ListTile(
                                onTap: () {},
                                title: const Text('Name'),
                                subtitle: Text(_currentUser.data!.name),
                                leading: const Icon(Icons.person),
                                shape: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                trailing: const Icon(Icons.chevron_right),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Card(
                              child: ListTile(
                                onTap: () {},
                                title: const Text('Email'),
                                subtitle: Text(_currentUser.data!.email),
                                leading: const Icon(Icons.email),
                                shape: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                trailing: const Icon(Icons.chevron_right),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Card(
                              child: ListTile(
                                onTap: () {},
                                title: const Text('Phone Number'),
                                subtitle: Text(_currentUser.data!.contact),
                                leading: const Icon(Icons.phone),
                                shape: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                trailing: const Icon(Icons.chevron_right),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Card(
                              // color: Colors.red[100],
                              borderOnForeground: false,
                              child: ListTile(
                                onTap: () {},
                                title: const Text('Blood Group'),
                                subtitle: Text(_currentUser.data!.bloodGroup),
                                leading: const Icon(Icons.bloodtype),
                                shape: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                trailing: const Icon(Icons.chevron_right),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Card(
                              child: ListTile(
                                onTap: () {},
                                title: const Text('Donor'),
                                subtitle: Text(
                                  _currentUser.data!.isDonor ? 'Yes' : 'No',
                                ),
                                leading: const Icon(Icons.bloodtype_sharp),
                                shape: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                trailing: Switch(
                                  activeColor: Colors.red,
                                  value: _currentUser.data!.isDonor,
                                  onChanged: (value) {},
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Card(
                              // color: Colors.red[100],
                              borderOnForeground: false,
                              child: ListTile(
                                onTap: () {},
                                title: const Text('Total Donations'),
                                subtitle: Text(
                                  _currentUser.data!.totalDonations.toString(),
                                ),
                                leading: const Icon(Icons.volunteer_activism),
                                shape: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                trailing: const Icon(Icons.chevron_right),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Card(
                              // color: Colors.red[100],
                              borderOnForeground: false,
                              child: ListTile(
                                onTap: () {},
                                title: const Text('Total Request Make'),
                                subtitle: Text(
                                  _currentUser.data!.totalRequests.toString(),
                                ),
                                leading: const Icon(Icons.bloodtype),
                                shape: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                trailing: const Icon(Icons.chevron_right),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  );
  }
}
