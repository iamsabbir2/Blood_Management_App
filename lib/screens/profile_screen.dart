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
  Map<String, dynamic>? _userData;
  bool _isLoading = false;
  bool _isSubmitting = false;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> _updateUserName(String newName) async {
    _user = FirebaseAuth.instance.currentUser;
    try {
      await _firestore.collection('users').doc(_user!.uid).update({
        'name': newName,
      });
      setState(() {
        _userData!['name'] = newName;
        _isSubmitting = false;
      });
    } catch (e) {
      print('Error updating user name : $e');
      setState(() {
        _isSubmitting = false;
      });
    }
  }

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
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    _fetchUser();
  }

  void _fetchUser() async {
    try {
      _user = FirebaseAuth.instance.currentUser;
      if (_user != null) {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .get();
        setState(() {
          _userData = snapshot.data() as Map<String, dynamic>;
        });
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hello'),
        ),
      );
    }
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
                  subtitle: Text(_userData?['name'] ?? 'No Name'),
                  onTap: () {
                    _showEditDialog(context, 'Name',
                        _userData?['name'] ?? 'No Name', _updateUserName);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text('Email'),
                  subtitle: Text(_userData?['email'] ?? 'No Email'),
                  onTap: () {
                    // navigate to edit email screen
                  },
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text('Phone Number'),
                  subtitle:
                      Text(_userData?['phoneNumber'] ?? 'No Phone Number'),
                  onTap: () {
                    // navigate to edit phone number screen
                  },
                ),

                //add leading and ending icons to the ListTile
                ListTile(
                  leading: Icon(Icons.bloodtype),
                  trailing: Icon(Icons.edit),
                  title: Text('Blood Group'),
                  subtitle: Text(_userData?['bloodGroup'] ?? 'No Blood Group'),
                  onTap: () {
                    // navigate to edit blood group screen
                  },
                ),

                //implemnt toggle switch for isDonor
                ListTile(
                  leading: Icon(Icons.bloodtype_sharp),
                  title: Text('Donor'),
                  trailing: Switch(
                    value: _userData?['isDonor'] ?? false,
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
