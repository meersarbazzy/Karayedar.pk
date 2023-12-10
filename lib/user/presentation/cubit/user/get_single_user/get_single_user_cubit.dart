import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:karayedar_pk/user/data/remote_data_source/firebase_remote_data_source_impl.dart';
import 'package:karayedar_pk/user/domain/entities/user_entity.dart';

part 'get_single_user_state.dart';

class GetSingleUserCubit extends Cubit<GetSingleUserState> {
  final db = UserFirebaseRemoteDataSourceImpl();

  GetSingleUserCubit():super(GetSingleUserInitial());

  Future<void> getSingleUser({required String uid}) async {
    try {

      final streamResponse = db.getSingleUser(uid);
      streamResponse.listen((users) {
        if(users.isNotEmpty) {
          emit(GetSingleUserLoaded(singleUser: users.first));
        }
      });

    } on SocketException catch (_) {
      emit(GetSingleUserFailure());
    } catch (_) {
      emit(GetSingleUserFailure());
    }
  }
}
