import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:karayedar_pk/chat/data_sources/firebase_remote_datasource_impl.dart';
import 'package:karayedar_pk/chat/entities/my_chat_entity.dart';

part 'my_chat_state.dart';

class MyChatCubit extends Cubit<MyChatState> {
  MyChatCubit():super(MyChatInitial());

  final db = FirebaseRemoteRepositoryImpl();

  Future<void> getMyChat({required String uid})async{
    emit(MyChatLoading());
    try {
      final myChat=db.getMyChat(uid);
      myChat.listen((myChatData) {
        emit(MyChatLoaded(myChat: myChatData));
      });
    } on SocketException catch (_) {} catch (_) {}
  }


}
