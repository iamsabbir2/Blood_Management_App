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

          return ListView.builder(
              itemCount: donors.length,
              itemBuilder: (ctx, index) {
                final donor = donors[index];
                return ListTile(
                  title: Text(donor['name']),
                  subtitle: Text('Blood Group: ${donor['bloodGroup']}'),
                );
              });
        },
      ),
    );
  }
}
