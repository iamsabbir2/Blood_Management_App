import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/patient_model.dart';

//service
import '../services/database_service.dart';

//models
import '../models/data_state.dart';

class PatientNotifier extends StateNotifier<DataState<List<PatientModel>>> {
  DatabaseService _databaseService = DatabaseService();
  PatientNotifier(this._databaseService) : super(DataState.loading()) {
    fetchBloodRequests();
  }

  void fetchBloodRequests() async {
    try {
      final requests = await _databaseService.fetchBloodRequests();
      state = DataState.loaded(requests);
    } catch (e) {
      state = DataState.error(e.toString());
    }
  }

  void addBloodRequest(PatientModel patient) async {
    try {
      await _databaseService.addBloodRequest(patient);
      fetchBloodRequests();
    } catch (e) {
      state = DataState.error(e.toString());
    }
  }

  void updateBloodRequest(PatientModel patient) async {
    try {
      await _databaseService.updateBloodRequest(patient);
      fetchBloodRequests();
    } catch (e) {
      state = DataState.error(e.toString());
    }
  }

  void updateNeedBloodUnits(String requestId, int units) async {
    try {
      await _databaseService.updateNeedBloodUnits(requestId, units);
      fetchBloodRequests();
    } catch (e) {
      state = DataState.error(e.toString());
    }
  }

  void updateIsRequestCompleted(
      String requestId, bool isRequestCompleted) async {
    try {
      await _databaseService.updateIsCompleteRequest(
          requestId, isRequestCompleted);
      fetchBloodRequests();
    } catch (e) {
      state = DataState.error(e.toString());
    }
  }
}

final patientProvider =
    StateNotifierProvider<PatientNotifier, DataState<List<PatientModel>>>(
        (ref) {
  return PatientNotifier(DatabaseService());
});
