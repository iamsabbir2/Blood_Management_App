import 'package:flutter/material.dart';

class CustomDropdownButtonField extends StatelessWidget {
  final List<String> items;
  final String hintText;
  final Function(String) onChanged;
  final double? height;
  final String labelText;
  final String value;
  const CustomDropdownButtonField({
    super.key,
    required this.items,
    required this.hintText,
    required this.value,
    required this.labelText,
    required this.onChanged,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: DropdownButtonFormField<String>(
          items: items.map((value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            onChanged(value!);
          },
          decoration: InputDecoration(
            hintText: hintText,
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            labelText: labelText,
          ),
          value: value,
        ),
      ),
    );
  }
}
