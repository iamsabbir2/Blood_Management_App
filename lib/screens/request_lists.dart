//packags
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//providers
import '../providers/patient_provider.dart';

class RequestLists extends ConsumerWidget {
  const RequestLists({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientState = ref.watch(patientProvider);
    final patients = patientState.data ?? [];
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
                        return ListTile(
                          title: Text(patient.name),
                          subtitle: Text(patient.bloodGroup),
                        );
                      },
                    ),
    );
  }
}
