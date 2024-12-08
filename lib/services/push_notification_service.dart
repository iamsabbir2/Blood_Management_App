import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:logger/logger.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> requestNotificationPermissions() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      Logger().i('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      Logger().i('User granted provisional permission');
    } else {
      Logger().i('User Declined or has not accepted permissioin');
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Logger().i('A new onMessageOpenedApp event was published!');
      Logger().i('Message data: ${message.messageId}');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Logger().i('Received a foreground message: ${message.messageId}');
      if (message.notification != null) {
        Logger().i(
            'Message also contained a notification: ${message.notification!.title}');
      }
    });
  }

  Future<String?> getFcmToken() async {
    String? token = await _firebaseMessaging.getToken();
    return token;
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
    Logger().i(client);

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );
    Logger().i(credentials.accessToken.data);
    client.close();
    return credentials.accessToken.data;
  }

  Future<void> sendPushMessage(Map<String, dynamic> message) async {
    try {
      final String serverKey = await getAccessToken();
      Logger().i(serverKey);
      String endpointCloudFirebaseCloudMessagin =
          'https://fcm.googleapis.com/v1/projects/bloodmanagementapp-b2314/messages:send';

      final http.Response response = await http.post(
        Uri.parse(
          endpointCloudFirebaseCloudMessagin,
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $serverKey',
        },
        body: jsonEncode(message),
      );

      Logger().i(response.body);
      Logger().i(response.statusCode);

      if (response.statusCode == 200) {
        Logger().i('Notification sent successfully');
      } else {
        Logger().i('Failed to send notification');
      }
    } catch (e) {
      Logger().i(e);
    }
  }

  void setupTokenRefreshListener() {
    Logger().i('Setting up token refresh checker');
    _checkToken();
    Future.delayed(const Duration(hours: 24), _checkToken);
  }

  Future<void> _checkToken() async {
    try {
      String? token;
      if (kIsWeb) {
        if (await _isSupportedBrowser()) {
          token = await FirebaseMessaging.instance.getToken(
            vapidKey:
                'BE7twew0v0Yt-fDD68pP40FgH2u6wReDBRG-RHFjdwUKNmx-IXxbN8N0S8Piqmm7GGrMmBjqinqVTCr32wXEANw',
          );
        } else {
          Logger().e('Browser not supported');
        }
      } else {
        token = await FirebaseMessaging.instance.getToken();
      }
      if (token != null) {
        Logger().i('Token: $token');

        if (FirebaseAuth.instance.currentUser != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            'fcmToken': token,
          });
          Logger().i('Token updated successfully');
        } else {
          Logger().e('No current user found');
        }
      }
    } catch (e) {
      Logger().e('Error in token refresh checker: $e');
    }
  }

  Future<bool> _isSupportedBrowser() async {
    // Check if the browser supports service workers and the Push API
    return await FirebaseMessaging.instance.isSupported();
  }
}
