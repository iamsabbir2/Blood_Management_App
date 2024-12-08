import 'package:flutter/material.dart';

class ShowRequest extends StatelessWidget {
  const ShowRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show Request'),
      ),
      body: const Card(
        child: Text(
          'No data choosen',
        ),
      ),
    );
  }
}
