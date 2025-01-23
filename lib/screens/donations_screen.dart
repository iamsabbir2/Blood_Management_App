import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/auth_service_firebase.dart';

class DonationsScreen extends StatefulWidget {
  const DonationsScreen({super.key});

  @override
  State<DonationsScreen> createState() {
    return _DonationsScreenState();
  }
}

class _DonationsScreenState extends State<DonationsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donations'),
      ),
      body: StreamBuilder(
          stream: _firestore.collection('request_response').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No donations yet.'));
            }
            final data = snapshot.data!.docs;
            final filteredDonations = data.where((donation) {
              return donation['donorId'] == auth.currentUser!.uid &&
                  donation['responseStatus'] == true;
            }).toList();
            if (filteredDonations.isEmpty) {
              return const Center(child: Text('No donations yet.'));
            }
            return ListView.builder(
              itemCount: filteredDonations.length,
              itemBuilder: (context, index) {
                final donation = filteredDonations[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      minLeadingWidth: 40,
                      leading: Text(
                        donation['bloodGroup'],
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      title: Text(donation['patientName']),
                      subtitle: const Text('successfully donated'),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
