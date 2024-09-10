import 'package:uuid/uuid.dart';

class UserModel {
  final String uid;
  final String name;
  final String phoneNumber;
  final String email;
  final String bloodGroup;
  final bool isDonor;

  UserModel({
    String? uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.bloodGroup,
    required this.isDonor,
  }) : uid = uid ?? Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'bloodGroup': bloodGroup,
      'isDonor': isDonor,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      bloodGroup: map['bloodGroup'],
      isDonor: map['isDonor'],
    );
  }
}
