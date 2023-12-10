import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? uid;
  final String? username;
  final String? email;

  final String? password;
  final String? confirmPassword;
  final String? otherUid;

  UserEntity({
    this.confirmPassword,
    this.uid,
    this.username,
    this.password,
    this.email,
    this.otherUid,
  });

  @override
  List<Object?> get props => [
        username,
        password,
        email,
        uid,
        confirmPassword,
        otherUid,
      ];
}
