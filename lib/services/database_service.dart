import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

//models
import '../models/user_model.dart';
import '../models/patient_model.dart';
import '../models/message_model.dart';
import '../models/chat_model.dart';

const String USER_COLLECION = 'users';
const String CHAT_COLLECTION = 'chats';
const String MESSAGE_COLLECTION = 'messages';
const String BLOOD_REQUEST_COLLECTION = 'blood_requests';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
    } catch (e) {
      Logger().i('Error in addUser : $e');
    }
  }

  Future<List<UserModel>> fetchUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      return snapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      Logger().i('Error in fetchUsers : $e');
      return [];
    }
  }

  Future<void> updateUserName(String uid, String name) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'name': name,
      });
    } catch (e) {
      Logger().i('Error in updateUserName : $e');
    }
  }

  Future<void> updateResponseStatus(String responseId) async {
    try {
      await _firestore.collection('request_response').doc(responseId).update({
        'responseStatus': true,
      });
    } catch (e) {
      Logger().i('Error in updateResponseStatus : $e');
    }
  }

  Future<void> updateDonationCount(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'totalDonations': FieldValue.increment(1),
      });
    } catch (e) {
      Logger().i('Error in updateDonationCount : $e');
    }
  }

  Future<void> updateUserPhoneNumber(String uid, String phoneNumber) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'phoneNumber': phoneNumber,
      });
    } catch (e) {
      Logger().i('Error in updateUserPhoneNumber : $e');
    }
  }

  Future<void> updateContactStatus(String uid, bool value) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'isContactHidden': value,
      });
    } catch (e) {
      Logger().i('Error in updateContactStatus : $e');
    }
  }

  Future<void> updateLastDonationTime(String uid, DateTime? time) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'lastDonationDate': time,
      });
    } catch (e) {
      Logger().i('Error in updateLastDonationTime : $e');
    }
  }

  Future<UserModel> fetchCurrentUser(String uid) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(uid).get();
    return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
  }

  Future<void> deleteRequest(String requestId) async {
    try {
      await _firestore.collection('blood_requests').doc(requestId).update({
        'isRequestDelete': true,
      });
    } catch (e) {
      Logger().i('Error in deleteRequest : $e');
    }
  }

  Future<List<PatientModel>> fetchBloodRequests() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('blood_requests').get();

      return snapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['isRequestComplete'] == false ||
            data['isRequestDelete'] == false;
      }).map((doc) {
        return PatientModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      Logger().i('Error in fetchBloodRequests : $e');
      return [];
    }
  }

  Future<void> addBloodRequest(PatientModel patient) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('blood_requests').add(patient.toMap());

      String requestId = docRef.id;
      await docRef.update({'requestId': requestId});
    } catch (e) {
      Logger().i('Error in addBloodRequest : $e');
    }
  }

  Future<void> updateBloodRequest(PatientModel patient) async {
    try {
      if (patient.requestId.isEmpty) {
        throw Exception('Invalid requestId');
      }
      await _firestore
          .collection('blood_requests')
          .doc(patient.requestId)
          .update({
        'currentUserUid': patient.currentUserUid,
        'name': patient.name,
        'bloodGroup': patient.bloodGroup,
        'units': patient.units,
        'transfusionDate': patient.transfusionDate,
        'transfusionTime': patient.transfusionTime,
        'hospital': patient.hospital,
        'contact': patient.contact,
        'address': patient.address,
        'description': patient.description,
        'age': patient.age,
        'haemoglobin': patient.haemoglobin,
        'isRequestComplete': patient.isRequestComplete,
      });
    } catch (e) {
      Logger().i('Error in updateBloodRequest : $e');
    }
  }

  Future<void> cancelBloodRequest(String requestId) async {
    try {
      await _firestore.collection('blood_requests').doc(requestId).delete();
    } catch (e) {
      Logger().i('Error in cancelBloodRequest : $e');
    }
  }

  Future<void> updateIsGoingToDonate(String uid, bool isGoingToDonate) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'isGoingToDonate': isGoingToDonate,
      });
    } catch (e) {
      Logger().i('Error in updateIsGoingToDonate : $e');
    }
  }

  Future<void> updateNeedBloodUnits(String requestId, int units) async {
    try {
      await _firestore.collection('blood_requests').doc(requestId).update({
        'units': units,
      });
    } catch (e) {
      Logger().i('Error in updateNeedBloodUnits : $e');
    }
  }

  Future<void> updateIsCompleteRequest(
      String requestId, bool isRequestComplete) async {
    try {
      await _firestore.collection('blood_requests').doc(requestId).update({
        'isRequestComplete': isRequestComplete,
      });
    } catch (e) {
      Logger().i('Error in updateIsCompleteRequest : $e');
    }
  }

  String getChatId(String userId1, String userId2) {
    List<String> users = [userId1, userId2];
    users.sort();
    return users.join('_');
  }

  List<String> extractParticipants(String chatId) {
    return chatId.split('_');
  }

  Future<void> addMessage(String chatId, MessageModel message) async {
    try {
      DocumentReference docRef = _firestore.collection('chats').doc(chatId);

      if (!await docRef.get().then((value) {
        return value.exists;
      })) {
        await docRef.set({
          'particpants': extractParticipants(chatId),
        });
      }
      DocumentReference messageRef =
          await docRef.collection('messages').add(message.toMap());
      String messageId = messageRef.id;
      await messageRef.update({
        'messageId': messageId,
      });
      await messageRef.update({
        'isSent': true,
      });
    } catch (e) {
      Logger().i('Error in addMessage : $e');
    }
  }

  Stream<List<ChatModel>> fetchAllChats(String currentUserId) {
    return _firestore
        .collection('chats')
        .where('particpants', arrayContains: currentUserId)
        .snapshots()
        .asyncMap((snapshot) async {
      List<ChatModel> chats = [];
      for (var doc in snapshot.docs) {
        UserModel otherUser;
        Map<String, dynamic> data = doc.data();
        List<String> participants = data['particpants'].cast<String>();
        final otherUserUid = participants[0] == currentUserId
            ? participants[1]
            : participants[0];

        final userSnapshot = await getUser(otherUserUid);

        otherUser =
            UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);

        final messageSnapshot = await _firestore
            .collection('chats')
            .doc(doc.id)
            .collection('messages')
            .orderBy('time', descending: true)
            .limit(1)
            .get();

        final message = messageSnapshot.docs.first.data();

        chats.add(
          ChatModel(
            uid: doc.id,
            otherUser: otherUser,
            messages: MessageModel.fromJson(message),
          ),
        );
      }
      return chats;
    });
  }

  Future<List<ChatModel>> fetchChats(String uid) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('chats')
          .where('particpants', arrayContains: uid)
          .get();

      List<ChatModel> chats = [];

      for (var doc in snapshot.docs) {
        UserModel otherUser;
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<String> participants = data['particpants'].cast<String>();
        final otherUserUid =
            participants[0] == uid ? participants[1] : participants[0];

        final userSnapshot = await getUser(otherUserUid);
        otherUser =
            UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);

        final messageSnapshot = await _firestore
            .collection('chats')
            .doc(doc.id)
            .collection('messages')
            .orderBy('time', descending: true)
            .limit(1)
            .get();

        final message = messageSnapshot.docs.first.data();

        chats.add(
          ChatModel(
            uid: doc.id,
            otherUser: otherUser,
            messages: MessageModel.fromJson(message),
          ),
        );
        chats.sort((a, b) {
          return b.messages.time.compareTo(a.messages.time);
        });
      }
      return chats.toList();
    } catch (e) {
      Logger().i('Error in fetchChats : $e');
      return [];
    }
  }

  Future<List<MessageModel>> fetchMessage(String chatId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('time', descending: true)
          .get();
      return snapshot.docs.map((doc) {
        return MessageModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      Logger().i('Error in fetchMessage : $e');
      return [];
    }
  }

  Stream<QuerySnapshot> fetchMessages(String chatID) {
    return _firestore
        .collection('chats')
        .doc(chatID)
        .collection('messages')
        .orderBy('time', descending: true)
        .snapshots();
  }

  Future<void> updateLastMessage(String chatId, MessageModel message) async {
    try {} catch (e) {
      Logger().i('Error in updateLastMessage : $e');
    }
  }

  Future<bool> isDonor(String uid) async {
    try {
      DocumentSnapshot snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .get(const GetOptions(source: Source.serverAndCache));
      if (snapshot.exists) {
        return snapshot.get(FieldPath(const ['isDonor']));
      } else {
        return false;
      }
    } catch (e) {
      Logger().i('Error in isDonor : $e');
      return false;
    }
  }

  Future<DocumentSnapshot> getUser(String uid) async {
    try {
      return await _firestore.collection('users').doc(uid).get();
    } catch (e) {
      Logger().i('Error in getUser : $e');
      return null as DocumentSnapshot;
    }
  }

  Future<void> updateRequestCount(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'totalRequests': FieldValue.increment(1),
      });
    } catch (e) {
      Logger().i('Error in updateRequestCount : $e');
    }
  }

  Future<void> updateTotalDonations(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'totalDonations': FieldValue.increment(1),
      });
    } catch (e) {
      Logger().i('Error in updateTotalDonations : $e');
    }
  }

  Future<bool> getDonors(String bloodGroup) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('isDonor', isEqualTo: true)
          .where('bloodGroup', isEqualTo: bloodGroup)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      Logger().i('Error in getDonors : $e');
      return false;
    }
  }

  Future<void> deleteUser(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }

  Stream<QuerySnapshot> getMessagesForUser(String uid) {
    return _firestore
        .collection('chats')
        .where(
          'particpants',
          arrayContains: uid,
        )
        .snapshots();
  }

  Future<QuerySnapshot> getLastMessageForChat(String chatId) async {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('time', descending: true)
        .limit(1)
        .get();
  }

  Future<void> updateMessageStatus(String chatId) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('receiverUid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((message) {
      final messages = message.docs;
      for (var message in messages) {
        message.reference.update({
          'isRead': true,
        });
      }
    });
  }
}
