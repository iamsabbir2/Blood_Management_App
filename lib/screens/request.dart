import 'package:flutter/material.dart';

class Request extends StatelessWidget {
  const Request({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Request Description',
        ),
      ),
      body: Center(
        child: Card(
          child: Container(
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
