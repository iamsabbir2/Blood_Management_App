import 'package:blood_management_app/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

//widgets
import '../widgets/custom_text_form_field.dart';
import '../widgets/custom_dropdown_button_field.dart';
import '../widgets/custom_elevated_button.dart';

//models
import '../models/patient_model.dart';

//services
import '../services/navigation_service.dart';

//providers
import '../providers/patient_provider.dart';

class EditRequest extends ConsumerStatefulWidget {
  final PatientModel patient;
  const EditRequest({
    super.key,
    required this.patient,
  });

  @override
  ConsumerState<EditRequest> createState() => _EditRequestState();
}

class _EditRequestState extends ConsumerState<EditRequest> {
  bool _isLoading = false;
  late String _requestId;
  late String _currentUserUid;
  late String _name;
  late String _blood;
  late String _location;
  late int _bagno;
  late String _phone;
  late String _hospital;
  late String _date;
  late String _time;
  late String _description;
  late String _countryCode;
  late bool _isRequesComplete;

  int? _age;
  double? _haemoglobin;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestId = widget.patient.requestId;
    _currentUserUid = widget.patient.currentUserUid;
    _name = widget.patient.name;
    _blood = widget.patient.bloodGroup;
    _location = widget.patient.address;
    _bagno = widget.patient.units;
    _phone = widget.patient.contact;
    _hospital = widget.patient.hospital;
    _date = widget.patient.transfusionDate;
    _time = widget.patient.transfusionTime;
    _description = widget.patient.description;
    _age = widget.patient.age;
    _haemoglobin = widget.patient.haemoglobin;
    _countryCode = '+880';
    _isRequesComplete = widget.patient.isRequestComplete;

    _dateController.text = _date;
    _timeController.text = _time;
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

      final patient = PatientModel(
        address: _location,
        age: _age as int,
        bloodGroup: _blood,
        contact: _phone,
        currentUserUid: _currentUserUid,
        description: _description,
        haemoglobin: _haemoglobin as double,
        hospital: _hospital,
        isRequestComplete: _isRequesComplete,
        name: _name,
        requestId: _requestId,
        transfusionDate: _date,
        transfusionTime: _time,
        units: _bagno,
      );

      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Confirm Request'),
              content:
                  const Text('Are you sure you want to edit this request?'),
              actions: [
                TextButton(
                  onPressed: () {
                    NavigationService().goBack();
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () async {
                    NavigationService().goBack();
                    try {
                      setState(() {
                        _isLoading = true;
                      });
                      ref
                          .read(patientProvider.notifier)
                          .updateBloodRequest(patient);
                      await Future.delayed(const Duration(seconds: 3));

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Request Update Successfully'),
                          ),
                        );
                      }
                    } catch (e) {
                      Logger().e('Problem in updating request: $e');
                    }
                    setState(() {
                      _isLoading = false;
                    });
                    NavigationService().goBack();
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          });
    }

    setState(() {
      _isLoading = false;
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
        title: const Text('Edit Request'),
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
    String? initialValue,
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
      initialValue: initialValue,
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
            'Update Request',
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
            initialValue: _name,
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
                  initialValue: _age?.toString(),
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
                      _bagno = int.tryParse(value) ?? 0;
                    });
                  },
                  'Units of blood',
                  'Amount of blood',
                  'Please enter a valid name',
                  '',
                  keyboardType: TextInputType.number,
                  initialValue: _bagno.toString(),
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
                  initialValue: _haemoglobin?.toString(),
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
                () {
                  _selectDate();
                },
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
            initialValue: _phone.replaceFirst(_countryCode, ''),
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
            initialValue: _hospital,
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
            initialValue: _location,
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
            initialValue: _description,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4.0,
              vertical: 8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _requestButton(),
                ),
                Expanded(
                  child: CustomTextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: const Text('Warning!'),
                              content:
                                  const Text('Are you sure to delete request?'),
                              actions: [
                                CustomElevatedButton(
                                  isLoading: false,
                                  onPressed: () {
                                    NavigationService().goBack();
                                  },
                                  title: 'No',
                                  width: 50,
                                  height: 32,
                                ),
                                CustomTextButton(
                                  onPressed: () {
                                    NavigationService().goBack();
                                    ref
                                        .read(patientProvider.notifier)
                                        .deleteBloodRequest(_requestId);
                                    ref
                                        .read(patientProvider.notifier)
                                        .fetchBloodRequests();
                                    NavigationService().goBack();
                                  },
                                  title: 'Yes',
                                  isLoading: false,
                                ),
                              ],
                            );
                          });
                    },
                    title: 'Delete Request',
                    isLoading: false,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _requestButton() {
    return CustomElevatedButton(
      isLoading: _isLoading,
      onPressed: () {
        _request();
      },
      title: 'Update',
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
