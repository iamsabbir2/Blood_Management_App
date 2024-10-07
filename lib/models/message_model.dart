class MessageModel {
  String messageId;
  final String message;
  final String senderUid;
  final String receiverUid;
  final String time;
  final bool isRead;
  final bool isDelivered;
  final bool isSent;

  MessageModel({
    required this.messageId,
    required this.message,
    required this.senderUid,
    required this.receiverUid,
    required this.time,
    this.isRead = false,
    this.isDelivered = false,
    this.isSent = false,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json['messageId'],
      message: json['message'],
      senderUid: json['senderUid'],
      receiverUid: json['receiverUid'],
      time: json['time'],
      isRead: json['isRead'],
      isDelivered: json['isDelivered'],
      isSent: json['isSent'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'message': message,
      'senderUid': senderUid,
      'receiverUid': receiverUid,
      'time': time,
      'isRead': isRead,
      'isDelivered': isDelivered,
      'isSent': isSent,
    };
  }
}
