import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:karayedar_pk/chat/entities/my_chat_entity.dart';

class MyChatModel extends MyChatEntity {
  MyChatModel({
    final String? senderName,
    final String? recipientName,
    final String? channelId,
    final String? recipientUID,
    final String? senderUID,
    final String? profileUrl,
    final String? recentTextMessage,
    final bool? isRead,
    final Timestamp? time,
    final bool? isArchived,
    final String? recipientPhoneNumber,
    final String? senderPhoneNumber,
    final String? subjectName,
    final String? communicationType,
  }) : super(
      senderName:senderName,
      recipientName:recipientName,
      channelId:channelId,
      recipientUID:recipientUID,
      senderUID:senderUID,
      profileUrl:profileUrl,
      recentTextMessage:recentTextMessage,
      isRead:isRead,
      time:time,
      isArchived:isArchived,
      recipientPhoneNumber:recipientPhoneNumber,
      senderPhoneNumber:senderPhoneNumber,
      subjectName:subjectName,
      communicationType:communicationType,
  );

factory MyChatModel.fromSnapshot(DocumentSnapshot snapshot) {
  return MyChatModel(
    senderName: snapshot.get('senderName'),
    recipientName: snapshot.get('recipientName'),
    channelId: snapshot.get('channelId'),
    recipientUID: snapshot.get('recipientUID'),
    senderUID: snapshot.get('senderUID'),
    profileUrl: snapshot.get('profileUrl'),
    recentTextMessage: snapshot.get('recentTextMessage'),
    isRead: snapshot.get('isRead'),
    time: snapshot.get('time'),
    isArchived: snapshot.get('isArchived'),
    recipientPhoneNumber: snapshot.get('recipientPhoneNumber'),
    senderPhoneNumber: snapshot.get('senderPhoneNumber'),
    subjectName: snapshot.get('subjectName'),
    communicationType: snapshot.get('communicationType'),
  );
}

Map<String, dynamic> toDocument() {
  return {
    "senderName": senderName,
    "recipientName": recipientName,
    "channelId": channelId,
    "recipientUID": recipientUID,
    "senderUID": senderUID,
    "profileUrl": profileUrl,
    "recentTextMessage": recentTextMessage,
    "isRead": isRead,
    "time": time,
    "isArchived": isArchived,
    "recipientPhoneNumber": recipientPhoneNumber,
    "senderPhoneNumber": senderPhoneNumber,
    "subjectName":subjectName,
    "communicationType":communicationType
  };
}
}
