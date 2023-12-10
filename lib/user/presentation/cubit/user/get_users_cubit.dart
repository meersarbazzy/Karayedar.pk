import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:karayedar_pk/user/data/remote_data_source/firebase_remote_data_source_impl.dart';
import 'package:karayedar_pk/user/domain/entities/user_entity.dart';

part 'get_users_state.dart';

class GetUsersCubit extends Cubit<GetUsersState> {

  final db = UserFirebaseRemoteDataSourceImpl();

  GetUsersCubit() : super(GetUsersInitial());

  Future<void> getAllUsers() async {
    try {

      final streamResponse = db.getUsers();
      streamResponse.listen((users) {
        emit(GetUsersLoaded(users: users));
      });

    } on SocketException catch (_) {
      emit(GetUsersFailure());
    } catch (_) {
      emit(GetUsersFailure());
    }
  }

  Future<void> updateUser({required UserEntity user}) async {
    try {
      await db.updateUser(user);
    } on SocketException catch (_) {
      emit(GetUsersFailure());
    } catch (_) {
      emit(GetUsersFailure());
    }
  }
}
