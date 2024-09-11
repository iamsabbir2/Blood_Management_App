import 'package:flutter/material.dart';

class BloodRequest extends StatelessWidget {
  const BloodRequest({super.key});
  @override
  Widget build(BuildContext context) {
    String _name = '';
    String _blood = 'A+';

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
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    label: Text(
                      'Location',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    label: Text(
                      'BloodType',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    label: Text(
                      'Amount of bag',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    label: Text(
                      'Phone',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    label: Text(
                      'Date',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    label: Text(
                      'Description',
                    ),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text(
              'Request',
            ),
          )
        ],
      ),
    );
  }
}
