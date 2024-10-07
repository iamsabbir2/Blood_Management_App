import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  bool _isLoading = false;
  bool _isSubmitting = false;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
              child: Text('Cancel'),
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
                  child: Text('Save'),
                ),
                if (_isSubmitting) CircularProgressIndicator(),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                ),
                const SizedBox(height: 10),

                ListTile(
                  leading: Icon(Icons.person),
                  trailing: Icon(Icons.edit),
                  title: Text('Name'),
                  subtitle: Text('No Name'),
                  onTap: () {
                    _showEditDialog(context, 'Name', 'No Name', (value) {});
                  },
                ),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text('Email'),
                  subtitle: Text('No Email'),
                  onTap: () {
                    // navigate to edit email screen
                  },
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text('Phone Number'),
                  subtitle: Text('No Phone Number'),
                  onTap: () {
                    // navigate to edit phone number screen
                  },
                ),

                //add leading and ending icons to the ListTile
                ListTile(
                  leading: Icon(Icons.bloodtype),
                  trailing: Icon(Icons.edit),
                  title: Text('Blood Group'),
                  subtitle: Text('No Blood Group'),
                  onTap: () {
                    // navigate to edit blood group screen
                  },
                ),

                //implemnt toggle switch for isDonor
                ListTile(
                  leading: Icon(Icons.bloodtype_sharp),
                  title: Text('Donor'),
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {
                      // update isDonor value
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
