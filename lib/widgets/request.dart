import 'package:blood_management_app/services/database_service.dart';
import 'package:blood_management_app/services/push_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'package:flutter/foundation.dart';

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseService _databaseService = DatabaseService();
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
  final PushNotificationService _pushNotificationService =
      PushNotificationService();

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
        final Map<String, dynamic> message = {
          'message': {
            'token': token,
            'notification': {
              'title': 'New Blood Request',
              'body': 'A new blood request has been made by someone',
            },
          }
        };
        await _pushNotificationService.sendPushMessage(message);
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
        isRequestComplete: false,
        isRequestDelete: false,
        contact: _phone,
        address: _location,
        description: _description,
        age: _age as int,
        haemoglobin: _haemoglobin as double,
      );

      if (await isDonorAvailable(_blood)) {
        try {
          ref.watch(patientProvider.notifier).addBloodRequest(patient);
          _databaseService.updateRequestCount(currentUserUid);
          ref.watch(patientProvider.notifier).fetchBloodRequests();
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
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No donors available for this blood group'),
            ),
          );
        }
      }
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

  Future<bool> isDonorAvailable(String bloodGroup) async {
    return _databaseService.getDonors(bloodGroup);
  }

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
        padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 128 : 8.0),
        child: SingleChildScrollView(
          child: _form(),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Card(
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8,
                ),
                child: Text(
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
              '^[a-zA-Z]+([ \'-][a-zA-Z]+)*\$',
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
                    '^[1-9][0-9]*\$',
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
                    'Please enter a valid number',
                    '^[1-9][0-9]*\$',
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
                    '^\\d{1,2}(\\.\\d)?\$',
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
              '^1[3-9]\\d{8}\$',
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
              '^[A-Za-z\\s&\'-.]+\$',
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
