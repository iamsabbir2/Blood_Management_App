import 'package:flutter/material.dart';

class Request extends StatelessWidget {
  const Request({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Request Description',
        ),
      ),
      body: const Center(
        child: Card(
          child: SizedBox(
            height: 100,
            child: Text(
              'Here details would be shown',
            ),
          ),
        ),
      ),
    );
  }
}
