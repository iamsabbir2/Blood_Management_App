import 'package:logger/web.dart';

class PatientModel {
  String requestId;
  String currentUserUid;
  String name;
  String bloodGroup;
  int units;
  String transfusionDate;
  String transfusionTime;
  String hospital;
  String contact;
  String address;
  String description;
  int age;
  double haemoglobin;
  bool isRequestComplete;
  bool isRequestDelete;

  PatientModel({
    required this.requestId,
    required this.currentUserUid,
    required this.name,
    required this.bloodGroup,
    required this.units,
    required this.transfusionDate,
    required this.transfusionTime,
    required this.hospital,
    required this.contact,
    required this.address,
    required this.description,
    required this.age,
    required this.haemoglobin,
    this.isRequestComplete = false,
    this.isRequestDelete = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'haemoglobin': haemoglobin,
      'address': address,
      'age': age,
      'bloodGroup': bloodGroup,
      'contact': contact,
      'currentUserUid': currentUserUid,
      'description': description,
      'hospital': hospital,
      'isRequestComplete': isRequestComplete,
      'isRequestDelete': isRequestDelete,
      'name': name,
      'requestId': requestId,
      'transfusionDate': transfusionDate,
      'transfusionTime': transfusionTime,
      'units': units,
    };
  }

  factory PatientModel.fromMap(Map<String, dynamic> map) {
    return PatientModel(
      address: map['address'],
      age: map['age'] as int,
      bloodGroup: map['bloodGroup'],
      contact: map['contact'],
      currentUserUid: map['currentUserUid'],
      description: map['description'],
      hospital: map['hospital'],
      haemoglobin: map['haemoglobin'] is int
          ? (map['haemoglobin'] as int).toDouble()
          : map['haemoglobin'] as double,
      isRequestComplete: map['isRequestComplete'] as bool,
      isRequestDelete: map['isRequestDelete'] as bool,
      name: map['name'],
      requestId: map['requestId'] as String,
      transfusionDate: map['transfusionDate'],
      transfusionTime: map['transfusionTime'],
      units: map['units'] as int,
    );
  }
}
