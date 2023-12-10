import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:karayedar_pk/user/data/remote_data_source/firebase_remote_data_source_impl.dart';

part '../auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final db = UserFirebaseRemoteDataSourceImpl();

  AuthCubit() : super(AuthInitial());


  Future<void> appStarted()async{
    try{
      bool isSignIn=await db.isSignIn();

      if (isSignIn==true){
        final uid=await db.getCurrentUid();

        emit(Authenticated(uid:uid));
      }else
        emit(UnAuthenticated());

    }catch(_){
      emit(UnAuthenticated());
    }
  }
  Future<void> loggedIn()async{
    try{
      final uid=await db.getCurrentUid();

      emit(Authenticated(uid: uid));
    }catch(_){

      emit(UnAuthenticated());
    }
  }
  Future<void> loggedOut()async{
    try{
      await db.signOut();
      emit(UnAuthenticated());
    }catch(_){
      emit(UnAuthenticated());
    }
  }




}