import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:karayedar_pk/chat/data_sources/firebase_remote_datasource_impl.dart';

part 'single_user_state.dart';

class SingleUserCubit extends Cubit<SingleUserState> {
  SingleUserCubit():super(SingleUserInitial());


  final db = FirebaseRemoteRepositoryImpl();

  Future<void> getSingleUser({required String uid}) async {
    emit(SingleUserLoading());
    final streamResponse =await db.getCurrentUId();
    emit(SingleUserLoaded(uid: streamResponse!));
  }
}
