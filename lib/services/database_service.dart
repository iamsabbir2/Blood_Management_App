import 'package:cloud_firestore/cloud_firestore.dart';

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
      return snapshot.docs.map((doc) {
        print('successfully fetched');

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
    } catch (e) {
      print('problem in addMessage');
      print(e);
    }
  }

  Future<List<MessageModel>> fetchMessages(String chatId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
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

  Future<ChatModel> getChats(String uid) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('chats')
          .where('particpants', arrayContains: uid)
          .get();

      ChatModel chatModel = ChatModel();

      for (var doc in snapshot.docs) {
        UserModel otherUser;
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        //print(data);
        List<String> participants = data['particpants'].cast<String>();
        final otherUserUid =
            participants[0] == uid ? participants[1] : participants[0];

        final userSnapshot = await getUser(otherUserUid);

        otherUser =
            UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);

        final messageStream = await _firestore
            .collection('chats')
            .doc(doc.id)
            .collection('messages')
            .snapshots();
        print('messageStream: $messageStream');

        messageStream.listen((messageSnapshot) {
          print('messageSnapshot: $messageSnapshot');
          final message = messageSnapshot.docs.map((doc) {
            return MessageModel.fromJson(doc.data());
          }).toList();

          chatModel = ChatModel(
            uid: doc.id,
            otherUser: otherUser,
            messages: message,
          );
        });

        print('otherUser: $otherUser');
      }
      return chatModel;
    } catch (e) {
      print('problem in getChats');
      print(e);
      return ChatModel();
    }
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

  DatabaseService() {}
}
