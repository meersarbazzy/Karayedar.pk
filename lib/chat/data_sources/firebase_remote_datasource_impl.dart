import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:karayedar_pk/chat/entities/my_chat_entity.dart';
import 'package:karayedar_pk/chat/entities/text_messsage_entity.dart';
import 'package:karayedar_pk/chat/models/my_chat_model.dart';
import 'package:karayedar_pk/chat/models/text_message_model.dart';

import 'firebase_remote_datasouce.dart';

class FirebaseRemoteRepositoryImpl {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;


  Future<void> addToMyChat(MyChatEntity myChatEntity) async {
    final myChatRef = fireStore
        .collection("users")
        .doc(myChatEntity.senderUID)
        .collection("myChat");
    final otherChatRef = fireStore
        .collection("users")
        .doc(myChatEntity.recipientUID)
        .collection("myChat");

    final myNewChatCurrentUser = MyChatModel(
      channelId: myChatEntity.channelId,
      senderName: myChatEntity.senderName,
      time: myChatEntity.time,
      recipientName: myChatEntity.recipientName,
      recipientUID: myChatEntity.recipientUID,
      senderUID: myChatEntity.senderUID,
      profileUrl: myChatEntity.profileUrl,
      isArchived: myChatEntity.isArchived,
      isRead: myChatEntity.isRead,
      recentTextMessage: myChatEntity.recentTextMessage,
      subjectName: myChatEntity.subjectName,
    ).toDocument();
    final myNewChatOtherUser = MyChatModel(
      channelId: myChatEntity.channelId,
      senderName: myChatEntity.recipientName,
      time: myChatEntity.time,
      recipientName: myChatEntity.senderName,
      recipientUID: myChatEntity.senderUID,
      senderUID: myChatEntity.recipientUID,
      profileUrl: myChatEntity.profileUrl,
      isArchived: myChatEntity.isArchived,
      isRead: myChatEntity.isRead,
      recentTextMessage: myChatEntity.recentTextMessage,
      subjectName: myChatEntity.subjectName,
    ).toDocument();
    myChatRef.doc(myChatEntity.recipientUID).get().then((myChatDoc) {
      if (!myChatDoc.exists) {
        myChatRef.doc(myChatEntity.recipientUID).set(myNewChatCurrentUser);
        otherChatRef.doc(myChatEntity.senderUID).set(myNewChatOtherUser);
        return;
      } else {
        myChatRef.doc(myChatEntity.recipientUID).update(myNewChatCurrentUser);
        otherChatRef.doc(myChatEntity.senderUID).set(myNewChatOtherUser);

        return;
      }
    });
  }


  Future<String> createOneToOneChatChannel(
      EngageUserEntity engageUserEntity) async {
    //User Collection Reference
    final userCollectionRef = fireStore.collection("users");
    var channelId = "";
    final oneToOneChatChannelRef = fireStore.collection("OneToOneChatChannel");
    //ChatChannelMap
  final idRef =  await userCollectionRef
        .doc(engageUserEntity.uid)
        .collection("chatChannel")
        .doc(engageUserEntity.otherUid)
        .get();


    if (idRef.exists) {

      return idRef.get('channelId');
    }

    channelId = oneToOneChatChannelRef.doc().id;

    var channel = {'channelId': channelId};

    oneToOneChatChannelRef.doc(channelId).set(channel);

    //currentUser
    userCollectionRef
        .doc(engageUserEntity.uid)
        .collection('chatChannel')
        .doc(engageUserEntity.otherUid)
        .set(channel);

    //otherUser
    userCollectionRef
        .doc(engageUserEntity.otherUid)
        .collection('chatChannel')
        .doc(engageUserEntity.uid)
        .set(channel);

    return channelId;
  }


  Future<void> deleteMySingleChat(MyChatEntity myChatEntity) async {
    final myChatRef = fireStore
        .collection("users")
        .doc(myChatEntity.senderUID)
        .collection("myChat")
        .doc(myChatEntity.recipientUID);

    myChatRef.delete();
  }


  Future<void> deleteUnWantedUserChat(MyChatEntity myChatEntity) async {
    // print("checkSenderId ${myChatEntity.senderUID}");
    final myChatRef = fireStore
        .collection("users")
        .doc(myChatEntity.senderUID)
        .collection("myChat")
        .doc(myChatEntity.recipientUID);

    await myChatRef.delete();
  }


  Future<void> deleteSingleMessage(AppEntity appEntity) async {
    final messagesRef = fireStore
        .collection("OneToOneChatChannel")
        .doc(appEntity.channelId)
        .collection("messages")
        .doc(appEntity.messageId);

    await messagesRef.delete();
  }


  Future<String> getChannelId(EngageUserEntity engageUserEntity) async {
    final userCollectionRef = fireStore.collection("users");
    // print(
    //     "uid ${engageUserEntity.uid} - otherUid ${engageUserEntity.otherUid}");
    return userCollectionRef
        .doc(engageUserEntity.uid)
        .collection('chatChannel')
        .doc(engageUserEntity.otherUid)
        .get()
        .then((chatChannelId) {
      if (chatChannelId.exists) {
        return chatChannelId.get('channelId');
      } else
        return Future.value(null);
    });
  }


  Stream<List<TextMessageEntity>> getMessages(String channelId) {
    final oneToOneChatChannelRef = fireStore.collection("OneToOneChatChannel");
    final messagesRef =
        oneToOneChatChannelRef.doc(channelId).collection("messages");

    ///FIXME: pagination required
    return messagesRef.orderBy('time').limit(30).snapshots().map((querySnap) =>
        querySnap.docs
            .map((queryDoc) => TextMessageModel.fromSnapshot(queryDoc))
            .toList());
  }


  Stream<List<MyChatEntity>> getMyChat(String uid) {
    final myChatRef =
        fireStore.collection("users").doc(uid).collection("myChat");

    return myChatRef.orderBy('time', descending: true).snapshots().map(
      (querySnapshot) {
        return querySnapshot.docs.map((queryDocumentSnapshot) {
          return MyChatModel.fromSnapshot(queryDocumentSnapshot);
        }).toList();
      },
    );
  }


  Future<void> sendTextMessage(
      TextMessageEntity textMessageEntity, String channelId) async {
    final messagesRef = fireStore
        .collection("OneToOneChatChannel")
        .doc(channelId)
        .collection("messages");

    //MessageId
    final messageId = messagesRef.doc().id;

    final newMessage = TextMessageModel(
      content: textMessageEntity.content,
      messageId: messageId,
      receiverName: textMessageEntity.receiverName,
      recipientId: textMessageEntity.recipientId,
      senderId: textMessageEntity.senderId,
      senderName: textMessageEntity.senderName,
      time: textMessageEntity.time,
      type: textMessageEntity.type,
    ).toDocument();

    messagesRef.doc(messageId).set(newMessage);
  }

  Future<String?> getCurrentUId() async {
    return auth.currentUser?.uid;
  }

}
