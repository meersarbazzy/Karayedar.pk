

class CreateChatChannelEntity{
  final String uid;
  final String otherUid;
  final String? recipientName;
  final String? senderName;
  final String? channelId;

  CreateChatChannelEntity({this.channelId,this.senderName,this.recipientName,required this.uid, required this.otherUid});
}