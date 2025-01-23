// ignore_for_file: unused_element

import 'package:blood_management_app/services/navigation_service.dart';
import 'package:blood_management_app/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import '../models/patient_model.dart';
import '../screens/show_request.dart';

//package
import 'package:flutter_riverpod/flutter_riverpod.dart';

//providers
import '../providers/patient_provider.dart';

//services
import '../services/auth_service_firebase.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/edit_request.dart';

class MyRequests extends ConsumerStatefulWidget {
  const MyRequests({super.key});

  @override
  ConsumerState<MyRequests> createState() => _MyRequestsState();
}

class _MyRequestsState extends ConsumerState<MyRequests> {
  final AuthService auth = AuthService();
  void _showRequest() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return const ShowRequest();
        },
      ),
    );
  }

  void _editRequest(PatientModel request) {
    NavigationService().navigateToPage(EditRequest(
      patient: request,
    ));
  }

  @override
  Widget build(BuildContext context) {
    ref.read(patientProvider.notifier).fetchBloodRequests();
    final requests = ref.watch(patientProvider);

    final myRequests = requests.data?.where((element) {
          return element.currentUserUid == auth.currentUser!.uid &&
              !element.isRequestDelete &&
              !element.isRequestComplete;
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
          final myRequest = myRequests[index];
          return Card(
            child: ListTile(
              title: Text(myRequest.name),
              leading: Text(myRequest.bloodGroup,
                  style: const TextStyle(fontSize: 20)),
              minLeadingWidth: 40,
              subtitle: Text('${myRequest.units.toString()}  units of blood'),
              onTap: () {
                NavigationService().navigateToRoute('/show_request');
              },
              trailing: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: const Text('Warning!'),
                        content: const Text(
                          'Are you sure to edit request?',
                        ),
                        actions: [
                          CustomElevatedButton(
                            isLoading: false,
                            onPressed: () {
                              NavigationService().goBack();
                            },
                            title: 'No',
                            width: 50,
                            height: 32,
                          ),
                          CustomTextButton(
                            onPressed: () {
                              NavigationService().goBack();
                              _editRequest(myRequest);
                            },
                            title: 'Yes',
                            isLoading: false,
                          )
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    )),
                child: const Text(
                  'Edit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
