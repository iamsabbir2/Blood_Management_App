import 'package:blood_management_app/services/auth_service.dart';
import 'package:blood_management_app/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class ResponsesScreen extends StatefulWidget {
  const ResponsesScreen({super.key});

  @override
  State<ResponsesScreen> createState() {
    return _ResponsesScreenState();
  }
}

class _ResponsesScreenState extends State<ResponsesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseService _databaseService = DatabaseService();
  final AuthService auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responses'),
      ),
      body: StreamBuilder(
        stream: _firestore.collection('request_response').snapshots(),
        builder: (context, snapshot) {
          Logger().i('snapshot: $snapshot');

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No responses yet.'));
          }

          final data = snapshot.data!.docs;
          final filteredResponse = data.where((response) {
            return response['recipientId'] == auth.currentUser!.uid &&
                response['responseStatus'] == false;
          }).toList();

          if (filteredResponse.isEmpty) {
            return const Center(child: Text('No responses yet.'));
          }

          return ListView.builder(
            itemCount: filteredResponse.length,
            itemBuilder: (context, index) {
              final response = filteredResponse[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    title: Text(response['donorName']),
                    subtitle: Text(response['responseMessage']),
                    onTap: () {},
                    trailing: ElevatedButton(
                      onPressed: () {
                        _databaseService.updateResponseStatus(
                          response['responseId'],
                        );

                        _databaseService.updateDonationCount(
                          response['donorId'],
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Response confirmed.'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
