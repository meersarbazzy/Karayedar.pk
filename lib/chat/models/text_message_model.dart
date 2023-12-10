import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:karayedar_pk/chat/entities/text_messsage_entity.dart';

class TextMessageModel extends TextMessageEntity {
  TextMessageModel({
    final String? recipientId,
    final String? senderId,
    final String? senderName,
    final String? type,
    final Timestamp? time,
    final String? content,
    final String? receiverName,
    final String? messageId,}) : super(
    recipientId: recipientId,
    senderId: senderId,
    senderName: senderName,
    type: type,
    time: time,
    content: content,
    receiverName: receiverName,
    messageId: messageId,
  );

  factory TextMessageModel.fromSnapshot(DocumentSnapshot snapshot) {
    return TextMessageModel(
      recipientId: snapshot.get('recipientId'),
      senderId: snapshot.get('senderId'),
      senderName: snapshot.get('senderName'),
      type: snapshot.get('type'),
      time: snapshot.get('time'),
      content: snapshot.get('content'),
      receiverName: snapshot.get('receiverName'),
      messageId: snapshot.get('messageId'),

    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "recipientId": recipientId,
      "senderId": senderId,
      "senderName": senderName,
      "type": type,
      "time": time,
      "content": content,
      "receiverName": receiverName,
      "messageId": messageId,
    };
  }
}
