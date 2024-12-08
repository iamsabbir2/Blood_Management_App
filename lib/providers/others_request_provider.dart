import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/patient_model.dart';

class OthersRequestsNotifier extends StateNotifier<List<PatientModel>?> {
  OthersRequestsNotifier() : super(null);

  void fetchOthersRequests() async {}
}
