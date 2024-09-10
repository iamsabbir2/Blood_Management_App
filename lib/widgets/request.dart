import 'package:flutter/material.dart';

class BloodRequest extends StatelessWidget {
  const BloodRequest({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Blood Request',
        ),
      ),
      body: Column(
        children: [
          Text(
            'Make a blood request',
          ),
          Form(
              child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
