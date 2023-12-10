import 'package:equatable/equatable.dart';
import 'package:karayedar_pk/chat/entities/my_chat_entity.dart';
import 'package:karayedar_pk/chat/entities/text_messsage_entity.dart';
import 'package:karayedar_pk/user/domain/entities/user_entity.dart';

class EngageUserEntity extends Equatable {
  final String? uid;
  final String? otherUid;

  EngageUserEntity({
    this.uid,
    this.otherUid,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [uid, otherUid];
}

class AppEntity {
  final int? postIndex;
  final String? uid;
  final String? reportType;
  final UserEntity? userEntity;
  final UserEntity? currentUser;
  final UserEntity? postByUser;
  final String? groupId;
  final List<UserEntity>? users;
  final String? channelId;
  final String? messageId;
  final String? currentUserId;
  final String? recipientId;
  final String? storyId;
  final String? callId;
  final String? topicContent;
  final String? topicContentId;
  final bool? profileContentSpoiler;

  AppEntity({
    this.postIndex,
    this.uid,
    this.reportType,
    this.userEntity,
    this.currentUser,
    this.postByUser,
    this.groupId,
    this.channelId,
    this.messageId,
    this.currentUserId,
    this.recipientId,
    this.storyId,
    this.callId,
    this.topicContent,
    this.topicContentId,
    this.users,
    this.profileContentSpoiler,
  });
}
