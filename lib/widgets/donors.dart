import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonorsList extends StatelessWidget {
  const DonorsList({super.key});
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Donors'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No donors found'),
            );
          }

          final donors = snapshot.data!.docs
              .where((doc) => doc.id != currentUser?.uid)
              .toList();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: donors.length,
              itemBuilder: (ctx, index) {
                final donor = donors[index];
                return ListTile(
                  minLeadingWidth: 43,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'List Tile',
                        ),
                      ),
                    );
                  },
                  leading: Text(
                    '${donor['bloodGroup']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  title: Row(
                    children: [
                      Icon(
                        Icons.person,
                      ),
                      Text(
                        donor['name'],
                      ),
                    ],
                  ),
                  subtitle: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_city,
                          ),
                          Text(
                            'Tangail',
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.send,
                          ),
                          Text(
                            'Can\'t Donate now!',
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                          ),
                          Text(
                            'hidden',
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Chat',
                              ),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.chat,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Phone',
                              ),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.phone,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
