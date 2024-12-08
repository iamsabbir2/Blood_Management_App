import 'package:flutter/material.dart';

class RequestInfo extends StatelessWidget {
  const RequestInfo({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RequestInfo Description',
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
