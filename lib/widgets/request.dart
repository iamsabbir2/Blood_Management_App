import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BloodRequest extends StatelessWidget {
  const BloodRequest({super.key});
  @override
  Widget build(BuildContext context) {
    String _name = '';
    String _blood = 'A+';
    String _location = '';
    String _bagno = '';
    String _phone = '';
    String _date = '';
    String _description = '';
    final _formKey = GlobalKey<FormState>();
    User? _user;
    final _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;

    void _request() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Column(
            children: [
              Text('${_name}'),
              Text('${_location}'),
              Text('${_blood}'),
              Text('${_bagno}'),
              Text('${_phone}'),
              Text('${_date}'),
              Text('${_description}'),
            ],
          ),
        ));
        try {
          _user = _auth.currentUser;

          if (_user != null) {
            await _firestore.collection('blood_requests').add(
              {
                'uid': _user!.uid,
                'name': _name,
                "location": _location,
                "blood_type": _blood,
                "bag_no": _bagno,
                "phone": _phone,
                "date": _date,
                "description": _description,
                "request_time": Timestamp.now(),
                'timestap': FieldValue.serverTimestamp(),
              },
            ).then(
              (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Request Submitted Successfully'),
                  ),
                );
              },
            ).catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Failde to submit request: $error',
                  ),
                ),
              );
            });
          }
          Navigator.of(context).pop();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${e}',
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'User not authenticated',
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        title: Text(
          'Blood Request',
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Make a blood request',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value == '') {
                                return 'Name field can\'t be empty';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _name = value!;
                            },
                            decoration: InputDecoration(
                              labelText: 'Name',
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == '') {
                                return '';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _location = newValue!;
                            },
                            decoration: InputDecoration(
                              label: Text(
                                'Location',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DropdownButtonFormField(
                            value: 'A+',
                            items: [
                              DropdownMenuItem(
                                value: 'A+',
                                child: Text(
                                  'A+',
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'A-',
                                child: Text('A-'),
                              ),
                              DropdownMenuItem(
                                value: 'B+',
                                child: Text('B+'),
                              ),
                              DropdownMenuItem(
                                value: 'B-',
                                child: Text('B-'),
                              ),
                              DropdownMenuItem(
                                value: 'AB+',
                                child: Text('AB+'),
                              ),
                              DropdownMenuItem(
                                value: 'AB-',
                                child: Text('AB-'),
                              ),
                              DropdownMenuItem(
                                value: 'O+',
                                child: Text('O+'),
                              ),
                              DropdownMenuItem(
                                value: 'O-',
                                child: Text('O-'),
                              ),
                            ],
                            onChanged: (value) {
                              _blood = value!;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == '') {
                                return '';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _bagno = newValue!;
                            },
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
                            validator: (value) {
                              if (value == '') {
                                return '';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _phone = newValue!;
                            },
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
                            validator: (value) {
                              if (value == '') {
                                return '';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _date = newValue!;
                            },
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
                            validator: (value) {
                              if (value == '') {
                                return '';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _description = newValue!;
                            },
                            decoration: InputDecoration(
                                label: Text(
                                  'Description',
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 20,
                                )),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.zero),
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.error.withAlpha(100),
                      ),
                      onPressed: _request,
                      child: Text(
                        'Request',
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
