import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class ResponsesScreen extends StatefulWidget {
  const ResponsesScreen({super.key});

  @override
  State<ResponsesScreen> createState() {
    return _ResponsesScreenState();
  }
}

class _ResponsesScreenState extends State<ResponsesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responses'),
      ),
    );
  }
}
