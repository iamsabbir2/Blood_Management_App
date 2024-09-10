import 'package:flutter_riverpod/flutter_riverpod.dart';

String otpCode = '';

final otpProvider = StateProvider<String>((ref) {
  return otpCode;
});
