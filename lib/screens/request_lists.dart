//packags
import 'package:blood_management_app/models/patient_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//providers
import '../providers/patient_provider.dart';

//services
import '../services/auth_service.dart';

class RequestLists extends ConsumerWidget {
  const RequestLists({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthService authService = AuthService();
    final patientState = ref.watch(patientProvider);
    List<PatientModel> patients = patientState.data ?? [];
    patients = patients.where((request) {
      return request.currentUserUid != authService.currentUser!.uid;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Request Lists',
        ),
      ),
      body: patientState.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : patientState.errorMessage != null
              ? Center(
                  child: Text('Error: ${patientState.errorMessage}'),
                )
              : patientState.data!.isEmpty
                  ? const Center(
                      child: Text('No requests found'),
                    )
                  : ListView.builder(
                      itemCount: patients.length,
                      itemBuilder: (context, index) {
                        final patient = patients[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: Card(
                            child: ListTile(
                              onTap: () {},
                              title: Text(patient.name),
                              subtitle: Text(
                                  '${patient.units.toString()} units of blood'),
                              minLeadingWidth: 40,
                              leading: Text(
                                patient.bloodGroup,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: (patient.currentUserUid ==
                                      authService.currentUser!.uid)
                                  ? const Text('Edit')
                                  : ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                      child: const Text(
                                        'Dontate',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
