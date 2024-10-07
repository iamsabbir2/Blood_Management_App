import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//widgets
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
      } catch (e) {
        print(e);
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
        title: const Text('Blood Request'),
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
