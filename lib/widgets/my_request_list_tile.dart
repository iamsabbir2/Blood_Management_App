import 'package:blood_management_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import '../models/patient_model.dart';
import '../services/auth_service.dart';

class MyRequestListTile extends StatelessWidget {
  final PatientModel patient;
  final AuthService _authService = AuthService();
  final VoidCallback onTap;
  MyRequestListTile({
    super.key,
    required this.patient,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Text('');
  }
}
