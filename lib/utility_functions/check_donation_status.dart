import 'package:shared_preferences/shared_preferences.dart';

Future<void> checkDonationEligibilityPeriodically(
    DateTime lastDonationTime) async {
  final now = DateTime.now();
  final prefs = await SharedPreferences.getInstance();

  // Retrieve the last check time from local storage
  final lastCheckedTimeString = prefs.getString('lastCheckedTime');
  DateTime? lastCheckedTime = lastCheckedTimeString != null
      ? DateTime.parse(lastCheckedTimeString)
      : null;

  // Check if 24 hours have passed since the last check
  if (lastCheckedTime == null ||
      now.difference(lastCheckedTime).inHours >= 24) {
    // Perform the eligibility check
    final isEligible = lastDonationTime.isBefore(
      now.subtract(const Duration(days: 120)),
    );

    if (isEligible) {
      print("Donor is eligible for donation.");
      // You can show a notification or update the UI accordingly
    } else {
      print("Donor is not eligible yet.");
    }

    // Update the last checked time
    await prefs.setString('lastCheckedTime', now.toIso8601String());
  }
}
