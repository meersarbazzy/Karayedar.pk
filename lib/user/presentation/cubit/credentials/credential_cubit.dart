import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:karayedar_pk/user/data/remote_data_source/firebase_remote_data_source_impl.dart';
import '../../../domain/entities/user_entity.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {

  final db = UserFirebaseRemoteDataSourceImpl();

  CredentialCubit() : super(CredentialInitial());

  Future<void> forgotPassword({required String email}) async {
    try {
      await db.forgotPassword(email);
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }

  Future<void> signInUser({required String email, required String password}) async {
    emit(CredentialLoading());
    try {
      await db.signInUser(UserEntity(email: email, password: password));
      emit(CredentialLoaded());
    } on FirebaseAuthException catch (e) {
      // Handling FirebaseAuth specific errors
      String errorMessage = _getFirebaseAuthErrorMessage(e);
      emit(CredentialFailure(message: errorMessage));
    } catch (e) {
      // Generic error handling
      emit(CredentialFailure(message: e.toString()));
    }
  }

  String _getFirebaseAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
    // Add more case handlers as necessary
      default:
        return 'An unexpected error occurred.';
    }
  }


  Future<void> signUpUser({required UserEntity user}) async {
    emit(CredentialLoading());
    try {
      await db.signUpUser(user);
      emit(CredentialLoaded());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }


  Future<void> signInWithGoogle()async{
    emit(CredentialLoading());
    try{
      await db.signInWithGoogle();
      emit(CredentialLoaded());
    }on SocketException catch(_){
      emit(CredentialFailure());
    }catch(_){
      emit(CredentialFailure());
    }
  }

}