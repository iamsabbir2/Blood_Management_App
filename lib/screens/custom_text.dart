import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({super.key});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        label: Text('Email'),
      ),
      onSaved: (newValue) {},
    );
  }
}
