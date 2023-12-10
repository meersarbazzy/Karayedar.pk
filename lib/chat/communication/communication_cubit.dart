import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:karayedar_pk/chat/data_sources/firebase_remote_datasouce.dart';
import 'package:karayedar_pk/chat/data_sources/firebase_remote_datasource_impl.dart';
import 'package:karayedar_pk/chat/entities/my_chat_entity.dart';
import 'package:karayedar_pk/chat/entities/text_messsage_entity.dart';

part 'communication_state.dart';

class CommunicationCubit extends Cubit<CommunicationState> {
  CommunicationCubit():super(CommunicationInitial());


  final db = FirebaseRemoteRepositoryImpl();


  Future<void> sendTextMessage(
      {required TextMessageEntity textMessageEntity, required EngageUserEntity engageUserEntity,required String channelId}) async {
    try {


      if (channelId ==""){


        db.getChannelId(engageUserEntity).then((chatChannelId)async {

          await db.sendTextMessage(
            textMessageEntity,
            chatChannelId,
          );
          await db.addToMyChat(MyChatEntity(
            profileUrl: "",
            time: Timestamp.now(),
            senderName: textMessageEntity.senderName,
            senderUID: textMessageEntity.senderId,
            recipientName: textMessageEntity.receiverName,
            recipientUID: textMessageEntity.recipientId,
            isRead: false,
            recentTextMessage: textMessageEntity.content,
            isArchived: false,
            subjectName: "",
            channelId: chatChannelId,
          ));
        });


      }else{

        await db.sendTextMessage(
          textMessageEntity,
          channelId,
        );
        await db.addToMyChat(MyChatEntity(
          profileUrl: "",
          time: Timestamp.now(),
          senderName: textMessageEntity.senderName,
          senderUID: textMessageEntity.senderId,
          recipientName: textMessageEntity.receiverName,
          recipientUID: textMessageEntity.recipientId,
          isRead: false,
          recentTextMessage: textMessageEntity.content,
          isArchived: false,
          subjectName: "",
          channelId: channelId,
        ));

      }


    } on SocketException catch (_) {
      emit(CommunicationFailure());
    } catch (_) {
      emit(CommunicationFailure());
    }
  }


  Future<void> addToMyMessage(
      {required TextMessageEntity textMessageEntity, required EngageUserEntity engageUserEntity,required String channelId}) async {
    try {


      if (channelId ==""){


        db.getChannelId(engageUserEntity).then((chatChannelId)async {
          await db.addToMyChat(MyChatEntity(
            profileUrl: "",
            time: Timestamp.now(),
            senderName: textMessageEntity.senderName,
            senderUID: textMessageEntity.senderId,
            recipientName: textMessageEntity.receiverName,
            recipientUID: textMessageEntity.recipientId,
            isRead: false,
            recentTextMessage: textMessageEntity.content,
            isArchived: false,
            subjectName: "",
            channelId: chatChannelId,
          ));
        });
      }else{
        await db.addToMyChat(MyChatEntity(
          profileUrl: "",
          time: Timestamp.now(),
          senderName: textMessageEntity.senderName,
          senderUID: textMessageEntity.senderId,
          recipientName: textMessageEntity.receiverName,
          recipientUID: textMessageEntity.recipientId,
          isRead: false,
          recentTextMessage: textMessageEntity.content,
          isArchived: false,
          subjectName: "",
          channelId: channelId,
        ));

      }


    } on SocketException catch (_) {
      emit(CommunicationFailure());
    } catch (_) {
      emit(CommunicationFailure());
    }
  }





  Future<void> getMessages(
      {required String channelId}) async {
    emit(CommunicationLoading());
    try {

      final messagesStreamData = db.getMessages(channelId);
      messagesStreamData.listen((messages) {
        emit(CommunicationLoaded(messages: messages));
      });
    } on SocketException catch (_) {
      emit(CommunicationFailure());
    } catch (_) {
      emit(CommunicationFailure());
    }
  }



  Future<void> createChatChannel(
      {required EngageUserEntity engageUserEntity}) async {
    try {
      await db.createOneToOneChatChannel(engageUserEntity);
    } on SocketException catch (_) {
      emit(CommunicationFailure());
    } catch (_) {
      emit(CommunicationFailure());
    }
  }

}
