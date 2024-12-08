import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  final List<String> items;
  final String value;
  final Function(String) onChanged;
  final String? title;
  const CustomDropdownButton({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      underline: Container(
        height: 1,
        color: Colors.white,
      ),
      iconDisabledColor: Colors.white,
      iconEnabledColor: Colors.white,
      hint: Text(
        title ?? 'Sort by District',
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      items: items.map((value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {
        onChanged(value!);
      },
    );
  }
}
