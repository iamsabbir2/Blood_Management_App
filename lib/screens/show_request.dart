import 'package:flutter/material.dart';

class ShowRequest extends StatelessWidget {
  const ShowRequest({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Request'),
      ),
      body: Card(
        child: Text(
          'No data choosen',
        ),
      ),
    );
  }
}
