import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum MessageType {
  TEXT,
  IMAGE,
  UNKNOWN,
}

class ChatMessage {
  final String senderId;
  final MessageType type;
  final String message;
  final DateTime sentTime;

  ChatMessage({
    required this.senderId,
    required this.type,
    required this.message,
    required this.sentTime,
  });

  factory ChatMessage.fromJSON(Map<String, dynamic> json) {
    MessageType messageType;
    switch (json['type']) {
      case 'TEXT':
        messageType = MessageType.TEXT;
        break;
      case 'IMAGE':
        messageType = MessageType.IMAGE;
        break;
      default:
        messageType = MessageType.UNKNOWN;
    }
    return ChatMessage(
      senderId: json['senderId'],
      type: messageType,
      message: json['message'],
      sentTime: DateTime.parse(json['sentTime']),
    );
  }

  Map<String, dynamic> toJson() {
    String messageType;
    switch (this.type) {
      case MessageType.TEXT:
        messageType = 'TEXT';
        break;
      case MessageType.IMAGE:
        messageType = 'IMAGE';
        break;
      default:
        messageType = 'UNKNOWN';
    }
    return {
      'senderId': senderId,
      'type': messageType,
      'message': message,
      'sentTime': Timestamp.fromDate(sentTime),
    };
  }
}
