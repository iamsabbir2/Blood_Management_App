import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as serviceControl;

//widgets7
import '../widgets/custom_text_form_field.dart';
import '../widgets/custom_dropdown_button_field.dart';
import '../widgets/custom_elevated_button.dart';

//models
import '../models/patient_model.dart';

//services
import '../services/auth_service.dart';
import '../services/navigation_service.dart';

//providers
import '../providers/patient_provider.dart';

class BloodRequest extends ConsumerStatefulWidget {
  const BloodRequest({super.key});

  @override
  ConsumerState<BloodRequest> createState() => _BloodRequestState();
}

class _BloodRequestState extends ConsumerState<BloodRequest> {
  String _name = '';
  String _blood = 'A+';
  String _location = '';
  int? _bagno;
  String _phone = '';
  String _hospital = '';
  String _date = '';
  String _time = '';
  String _description = '';
  String _countryCode = '+880';

  int? _age;
  double? _haemoglobin;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  bool _isRequesting = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "bloodmanagementapp-b2314",
      "private_key_id": "c8e11bb2e740376f4bf77a465b7d6ddd044f227d",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDDlm25PjhBpoUI\n46G6VU6ekCkotUwxlenj4w3Ey+Uwbr7Qdj/nSAZFkxfqyixsvGyZTdGFRAK92OgK\nKnmKSr1Cd8HjgdPp2yzGolbY1ZeEPCWukPpHRNcEm4MSgo4IVLX7KN0A9c2rqZet\neZTG5gmu00Fmr8GF0JbuC/c3hoz9BMELj6/gxvOgq4LTrgG9nzGC8QXBj90085b5\nG5KE36mRip+BsCFczs5THVpMWX8DovavYiR4lMvRVaiPSGdY1MKiLd6fAxk2YmCl\nBBvLsK+0wbsE6qzUO29HaFj0svdWFcgEzv+uWnOoP89Ij6b/QbNMEuG7+G8FLvmQ\nzxElEbW9AgMBAAECggEAGOalPA0ZnPQeIlpWzBIR0xqv/syMMZDwSPDunxRFbuPe\nm8w+SQwQrllylVQdkU9w9Rik+PZGchS0QB0Vwb9Ptq9oCjbMe8zJd9WRwIP7CR0e\nQAoZryqqxF2nM5tXCWT9kUcr0fQ5deY+1xlwUV1WtMEVJcVxGkALAy4XUKSq/Qhd\nWM2ojIfPU1hFcww7DZht0UEQRLft070KY9qS0FgoQFj20ebZo7W5XY0in+lxbbj/\nPiitKkSQABvJ2Yh0Dkp+hXb5WQsJbpwx9S5dpIHYaGsKFcX9dsOmDPLSBHfKPlc4\nouq8YHWizefZLvWEnMDJVJVjpVSqk+VjI5AnhRZeCQKBgQD5p824EkFN7pbBiitE\nWAuHCCjmBjjX5B16dW5t5W5SuD/acEMBuod9S/TeyaDzh224+pUX+075zCbuLkp2\neUcARh1DkK6kIQJG5WpH6gD1tkNRRzkLnvC9sjd1fZWaaj0WevmRw+/eXnUsubFJ\n2KR7VwZhHFAH071ZZlIGswIYOQKBgQDIjt93G1SJu3OLbGPk3cu1aXkoB7st+qnR\niBpw+A1eKo2wYpToopzS7utrq3bKk7B7jEnQPW690Zz37oZXU75dXVSj7CV8CTqu\npnhpv/+UAI0UKv6z0QNVdz/oguEc8i7sy7gDEYrvwHamH4Dd9ZxpHvIQKy5DI+oQ\nvQuxTN7hpQKBgA2rBjRBq5mcqlxGOEAxoc/uvm55gLsxHfwKWdVibjvRIo3O/5wk\nni5Z7joUR9+NVpB+B5OciqJabvczSZha42w8anW8ghMyS3GeNcdiJFNPezgD8jeU\nqBF6pFamXX5qupV0fh1g4M0H1tpwACjO15J5HTxL1IXZLdCrLWp4enDhAoGBAJJt\nxfgnSyS4aNcNzy1lRnrwRBYW9vHOBrjF31BFuzTaatKyVzg2qbtT1yyoZrXm+L5r\noeTZRYZviWR3kTwnF2EBaG+6VW/nKSIkxtum48pCUL692XKeEwoOY+m1zPgeVmZr\nIrGS2FbNtZL6g1MLJSSXBHMLo94/VYDdFbFgh4ZFAoGBAJUVFyYOvlrE2qMNFU0W\nG/V4vXdGZuT+M6pYkjqy+y+9NbirHgKu4OiyC5Q6zzqYUSKqmmAMcCOjMprCet0O\nkHbxEgRSjwLu7364aIZyiMHgXCFZvJUi2SzR1O9oOorfKEEmCC7DGfymYh5BhP4j\nc/Tqs/YUi2Qe1VAmTUEDV2D4\n-----END PRIVATE KEY-----\n",
      "client_email": "bloodmanagementapp-b2314@appspot.gserviceaccount.com",
      "client_id": "101165044090060648889",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/bloodmanagementapp-b2314%40appspot.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      'https://www.googleapis.com/auth/firebase.messaging',
      'https://www.googleapis.com/auth/cloud-platform',
      'https://www.googleapis.com/auth/firebase.database',
    ];

    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );

    client.close();
    return credentials.accessToken.data;
  }

  Future<void> _notifyAllUsers() async {
    try {
      QuerySnapshot users =
          await FirebaseFirestore.instance.collection('users').get();
      List<String> tokens = [];

      for (var doc in users.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['fcmToken'] != null &&
            data['uid'] != AuthService().currentUser!.uid) {
          tokens.add(data['fcmToken']);
        }
      }

      Logger().i(tokens);
      for (String token in tokens) {
        await _sendPushMessage(token);
      }
    } catch (e) {
      Logger().i(e);
    }
  }

  Future<void> _sendPushMessage(String token) async {
    try {
      final String serverKey = await getAccessToken();
      String endpointCloudFirebaseCloudMessagin =
          'https://fcm.googleapis.com/v1/projects/bloodmanagementapp-b2314/messages:send';

      final Map<String, dynamic> message = {
        'message': {
          'token': token,
          'notification': {
            'title': 'Blood Request',
            'body': 'A new blood request has been made',
          },
        }
      };
      final http.Response response = await http.post(
        Uri.parse(
          endpointCloudFirebaseCloudMessagin,
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authrization': 'Bearer $serverKey',
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        Logger().i('Notification sent successfully');
      } else {
        Logger().i('Failed to send notification');
      }
    } catch (e) {
      Logger().i(e);
    }
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2054),
    );

    if (picked != null) {
      setState(() {
        _date = '${picked.day}/${picked.month}/${picked.year}';
        _dateController.text = _date;
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _time = picked.format(context);
        _timeController.text = _time;
      });
    }
  }

  void _request() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final currentUserUid = AuthService().currentUser!.uid;

      final patient = PatientModel(
        requestId: '',
        currentUserUid: currentUserUid,
        name: _name,
        bloodGroup: _blood,
        units: _bagno as int,
        transfusionDate: _date,
        transfusionTime: _time,
        hospital: _hospital,
        contact: _phone,
        address: _location,
        description: _description,
        age: _age as int,
        haemoglobin: _haemoglobin as double,
      );

      try {
        ref.read(patientProvider.notifier).addBloodRequest(patient);

        await Future.delayed(const Duration(seconds: 3));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Request Submitted Successfully'),
            ),
          );
        }
        await _notifyAllUsers();
      } catch (e) {
        Logger().i(e);
      }
      setState(() {
        _isRequesting = false;
      });
      NavigationService().goBack();
    }
    setState(() {
      _isRequesting = false;
    });
  }

  final List<String> _bloodGroup = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Blood Request',
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: _form(),
          ),
        ),
      ),
    );
  }

  Widget _textField(
    Function(String) onSaved,
    String hintText,
    String title,
    String errorMessage,
    String regEx, {
    IconData? prefixIcon,
    TextEditingController? controller,
    Function? onTap,
    bool? filled,
    bool? readOnly,
    int? maxLines,
    double? height,
    TextInputType? keyboardType,
    String? prefixText,
    TextCapitalization? textCapitalization,
  }) {
    return CustomTextFormField(
      onSaved: onSaved,
      regEx: regEx,
      hintText: hintText,
      errorMessage: errorMessage,
      title: title,
      verticalPadding: 2,
      prefixIcon: prefixIcon,
      controller: controller,
      onTap: onTap,
      filled: filled,
      readOnly: readOnly,
      maxLines: maxLines,
      height: height,
      keyboardType: keyboardType,
      prefixText: prefixText,
      textCapitalization: textCapitalization,
    );
  }

  Widget _dropdownButton() {
    return CustomDropdownButtonField(
      items: _bloodGroup,
      hintText: 'Select blood group',
      labelText: 'Blood Group',
      onChanged: (value) {
        setState(() {
          _blood = value;
        });
      },
      value: _blood,
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text(
            'Make A Request',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(
                53,
                53,
                53,
                0.6,
              ),
            ),
          ),
          const SizedBox(height: 10),
          _textField(
            (value) {
              setState(() {
                _name = value;
              });
            },
            'Patient Name',
            'Patient Name',
            'Please enter a valid name',
            '',
            textCapitalization: TextCapitalization.words,
          ),
          Row(
            children: [
              Expanded(
                child: _textField(
                  (value) {
                    setState(() {
                      _age = int.tryParse(value);
                    });
                  },
                  '',
                  'Age',
                  'Please enter a valid age',
                  '',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: _dropdownButton()),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _textField(
                  (value) {
                    setState(() {
                      _bagno = int.tryParse(value);
                    });
                  },
                  'Units of blood',
                  'Amount of blood',
                  'Please enter a valid name',
                  '',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _textField(
                  (value) {
                    setState(() {
                      _haemoglobin = double.tryParse(value);
                    });
                  },
                  '',
                  'Haemoglobin',
                  'Please enter a valid amount of haemoglobin',
                  '',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _datetime(
                _date,
                'Date',
                'Select a date',
                _dateController,
                Icons.calendar_today,
                _selectDate,
              ),
              const SizedBox(width: 10),
              _datetime(
                _time,
                'Time',
                'Select a time',
                _timeController,
                Icons.access_time,
                _selectTime,
              ),
            ],
          ),
          _textField(
            (value) {
              setState(() {
                _phone = _countryCode + value;
              });
            },
            '',
            'Phone Number',
            'Please enter a valid phone number',
            '',
            keyboardType: TextInputType.phone,
            prefixText: _countryCode,
          ),
          _textField(
            (value) {
              setState(() {
                _hospital = value;
              });
            },
            '',
            'Hospital',
            'Please enter a valid hospital name',
            '',
            textCapitalization: TextCapitalization.words,
          ),
          _textField(
            (value) {
              setState(() {
                _location = value;
              });
            },
            '',
            'Location',
            'Please enter a valid address',
            '',
            textCapitalization: TextCapitalization.words,
          ),
          _textField(
            (value) {
              setState(() {
                _description = value;
              });
            },
            '',
            'Description',
            'Please enter valid description',
            '',
            maxLines: 3,
            height: 110,
            textCapitalization: TextCapitalization.sentences,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4.0,
              vertical: 8,
            ),
            child: _requestButton(),
          ),
        ],
      ),
    );
  }

  Widget _requestButton() {
    return CustomElevatedButton(
      isLoading: _isRequesting,
      onPressed: () {
        setState(() {
          _isRequesting = true;
        });
        _request();
      },
      title: 'Request',
    );
  }

  Widget _datetime(
    String entry,
    String title,
    String errorMessage,
    TextEditingController controller,
    IconData prefixIcon,
    Function onTap,
  ) {
    return Expanded(
      child: _textField(
        (value) {
          setState(() {
            entry = value;
          });
        },
        title,
        title,
        errorMessage,
        '',
        prefixIcon: prefixIcon,
        controller: controller,
        onTap: onTap,
        filled: true,
        readOnly: true,
      ),
    );
  }
}
