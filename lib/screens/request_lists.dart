import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestLists extends StatelessWidget {
  const RequestLists({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Request Lists',
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('blood_requests').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something wen\'t wrong',
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'Currently there is no request',
              ),
            );
          }
          final requestLists = snapshot.data!.docs;
          return ListView.builder(
            itemCount: requestLists.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {},
                title: Text(
                  '${requestLists[index]['name']}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
