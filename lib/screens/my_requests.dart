import 'package:flutter/material.dart';
import '../screens/show_request.dart';

//package
import 'package:flutter_riverpod/flutter_riverpod.dart';

//providers
import '../providers/patient_provider.dart';

//services
import '../services/auth_service.dart';

class MyRequests extends ConsumerStatefulWidget {
  const MyRequests({super.key});

  @override
  ConsumerState<MyRequests> createState() => _MyRequestsState();
}

class _MyRequestsState extends ConsumerState<MyRequests> {
  final auth = AuthService();
  void _showRequest() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return const ShowRequest();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final requests = ref.watch(patientProvider);

    final myRequests = requests.data?.where((element) {
          return element.currentUserUid == auth.currentUser!.uid;
        }).toList() ??
        [];

    if (myRequests.isEmpty) {
      return const Center(
        child: Text('No requests found'),
      );
    } else {
      return ListView.builder(
          itemCount: myRequests.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(myRequests[index].name),
              subtitle: Text(myRequests[index].bloodGroup),
            );
          });
    }
  }
}
