import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyRequests extends StatelessWidget {
  const MyRequests({super.key});
  @override
  Widget build(BuildContext context) {
    final _user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection('blood_requests').snapshots(),
      builder: (index, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Something wen\'t wrong!'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('Oh, No! \nYou do not make any requests!'),
          );
        }

        final myRequests = snapshot.data!.docs;
        myRequests.where(
          (element) {
            return element['uid'] == _user!.uid;
          },
        );

        myRequests.sort(
          (a, b) {
            return (b['timestap'] as Timestamp)
                .compareTo(a['timestap'] as Timestamp);
          },
        );

        return ListView.builder(
          itemCount: myRequests.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                '${myRequests[index]['name']}',
              ),
            );
          },
        );
      },
    );
  }
}
