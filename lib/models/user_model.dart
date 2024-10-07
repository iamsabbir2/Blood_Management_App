import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String contact;
  final bool isContactHidden;
  final String bloodGroup;
  final bool isDonor;
  final int totalDonations;
  final int totalRequests;
  DateTime? lastDonationDate;
  final bool canDonate;
  bool isGoingToDonate;
  bool? isOnline;
  bool? wasRecentlyActive;
  DateTime? lastActive;
  bool isTyping;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.contact,
    required this.isContactHidden,
    required this.bloodGroup,
    required this.isDonor,
    required this.totalDonations,
    required this.totalRequests,
    required this.lastDonationDate,
    required this.canDonate,
    required this.isGoingToDonate,
    //chatinfo
    this.isOnline,
    this.wasRecentlyActive,
    this.lastActive,
    required this.isTyping,
  });

  Map<String, dynamic> toMap() {
    return {
      'bloodGroup': bloodGroup,
      'canDonate': canDonate,
      'contact': contact,
      'email': email,
      'isContactHidden': isContactHidden,
      'isDonor': isDonor,
      'isGoingToDonate': isGoingToDonate,
      'isOnline': isOnline,
      'lastActive': lastActive,
      'isTyping': isTyping,
      'lastDonationDate': lastDonationDate,
      'name': name,
      'totalDonations': totalDonations,
      'totalRequests': totalRequests,
      'uid': uid,
      'wasRecentlyActive': wasRecentlyActive,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      name: data['name'],
      email: data['email'],
      contact: data['contact'],
      isContactHidden: data['isContactHidden'],
      bloodGroup: data['bloodGroup'],
      isDonor: data['isDonor'],
      totalDonations: data['totalDonations'],
      totalRequests: data['totalRequests'],
      lastDonationDate: data['lastDonationDate'] != null
          ? (data['lastDonationDate'] as Timestamp).toDate()
          : null,
      canDonate: data['canDonate'],
      isGoingToDonate: data['isGoingToDonate'],
      isOnline: data['isOnline'],
      wasRecentlyActive: data['wasRecentlyActive'],
      lastActive: data['lastActive'] != null
          ? (data['lastActive'] as Timestamp).toDate()
          : null,
      isTyping: data['isTyping'],
      uid: data['uid'],
    );
  }
}
