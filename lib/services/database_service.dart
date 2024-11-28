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
      print('problem in addUser');
      print(e);
    }
  }

  Future<List<UserModel>> fetchUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();
      return snapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('problem in fetching users');
      print(e);
      return [];
    }
  }

  Future<UserModel> fetchCurrentUser(String uid) async {
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(uid).get();
    return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
  }

  Future<List<PatientModel>> fetchBloodRequests() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('blood_requests').get();

      return snapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data['isRequestComplete'] == false;
      }).map((doc) {
        return PatientModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('problem in fetchBloodRequests');
      print(e);
      return [];
    }
  }

  Future<void> addBloodRequest(PatientModel patient) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('blood_requests').add({
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

      String requestId = docRef.id;
      await docRef.update({'requestId': requestId});
    } catch (e) {
      print('problem in addBloodRequest');
      print(e);
    }
  }

  Future<void> updateBloodRequest(PatientModel patient) async {
    try {
      print('its triggered');
      print(patient.requestId);
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
      print('problem in updateBloodRequest');
      print(e);
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
      print('problem in updateIsGoingToDonate');
      print(e);
    }
  }

  Future<void> updateNeedBloodUnits(String requestId, int units) async {
    try {
      await _firestore.collection('blood_requests').doc(requestId).update({
        'units': units,
      });
    } catch (e) {
      print('problem in updateNeedBloodUnits');
      print(e);
    }
  }

  Future<void> updateIsCompleteRequest(
      String requestId, bool isRequestComplete) async {
    try {
      await _firestore.collection('blood_requests').doc(requestId).update({
        'isRequestComplete': isRequestComplete,
      });
    } catch (e) {
      print('problem in updateIsCompleteRequest');
      print(e);
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

      print('messageId: $messageId');

      await messageRef.update({
        'messageId': messageId,
      });
      await messageRef.update({
        'isSent': true,
      });
    } catch (e) {
      print('problem in addMessage');
      print(e);
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
        final lastMessage = data['lastMessage'];
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
    // final QuerySnapshot snapshot = await
    //     .where('particpants', arrayContains: currentUserId)
    //     .get();

    // List<ChatModel> chats = [];

    // for (var doc in snapshot.docs) {
    //   UserModel otherUser;
    //   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    //   List<String> participants = data['particpants'].cast<String>();
    //   final lastMessage = data['lastMessage'];
    //   final otherUserUid =
    //       participants[0] == currentUserId ? participants[1] : participants[0];

    //   final userSnapshot = await getUser(otherUserUid);

    //   otherUser =
    //       UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);

    //   final messageSnapshot = await _firestore
    //       .collection('chats')
    //       .doc(doc.id)
    //       .collection('messages')
    //       .orderBy('time', descending: true)
    //       .limit(1)
    //       .get();

    //   final message = messageSnapshot.docs.first.data();

    //   chats.add(
    //     ChatModel(
    //       uid: doc.id,
    //       otherUser: otherUser,
    //       messages: MessageModel.fromJson(message),
    //       lastMessage: lastMessage,
    //     ),
    //   );
    // }

    // return chats;
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
        final lastMessage = data['lastMessage'];
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
      print('problem in fetchChats');
      print(e);
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
      print('problem in fetchMessages');
      print(e);
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
      print('problem in updateLastMessage');
      print(e);
    }
  }

  Future<DocumentSnapshot> getUser(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
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
