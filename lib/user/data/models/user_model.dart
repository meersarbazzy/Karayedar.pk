import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:karayedar_pk/user/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  final String? uid;
  final String? username;
  final String? email;

  UserModel({
    this.uid,
    this.username,
    this.email,
  }) : super(
          email: email,
          username: username,
          uid: uid,

        );


  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      email: snapshot['email'],
      username: snapshot['username'],
      uid: snapshot['uid'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "username": username,
      "email": email,
      "uid": uid,
    };
  }

}
