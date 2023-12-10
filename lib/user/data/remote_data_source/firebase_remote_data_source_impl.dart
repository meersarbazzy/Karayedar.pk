import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:karayedar_pk/user/data/models/user_model.dart';
import 'package:karayedar_pk/user/domain/entities/user_entity.dart';


class FirebaseCollectionConst {

  static const String users = "users";
}

class UserFirebaseRemoteDataSourceImpl {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn();



  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await account!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final information = (await firebaseAuth.signInWithCredential(credential)).user;
      final newUser= UserEntity(
          email: information?.email,
          uid: information?.uid,
          username: information?.displayName,
      );

      await getCreateCurrentUser(newUser);

    } catch (e) {
      print("some error occur while google sign in $e");
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (error) {
      print("Error resetting password: $error");
      throw error;
    }
  }


  Future<void> getCreateCurrentUser(UserEntity user) async {
    final userCollection = fireStore.collection("users");
    final uid = await getCurrentUid();
    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
        uid: uid,
        email: user.email,
        username: user.username,
      ).toDocument();
      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
        return;
      } else {
        print("user already exist");
        return;
      }
    }).catchError((error) {
      print("some error occurred");
    });
  }


  Future<String> getCurrentUid() async => firebaseAuth.currentUser!.uid;


  Future<bool> isSignIn() async => firebaseAuth.currentUser?.uid != null;


  Future<void> signInUser(UserEntity user) async {
    try {
      if (user.email!.isNotEmpty || user.password!.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(email: user.email!, password: user.password!);
      } else {

      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("User not found");
      } else if (e.code == "wrong-password") {}
    }
  }


  Future<void> signOut() async => await firebaseAuth.signOut();


  Future<void> signUpUser(UserEntity user) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: user.email!, password: user.password!).then((currentUser) async {
        if (currentUser.user?.uid != null) {
          getCreateCurrentUser(user);
        }
      });
      return;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        print("email is already used");
      } else {
        print("something went wrong");
      }
    }
    catch (_) {
      print("some error occur");
    }
  }



  Future<List<UserEntity>> getSingleUserFuture(String uid) {

    final userCollection = fireStore
        .collection(FirebaseCollectionConst.users).where("uid", isEqualTo: uid).limit(1);

    return userCollection.get().then((querySnapshot) => querySnapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList());

  }

  Stream<List<UserEntity>> getSingleUser(String uid) {

    final userCollection = fireStore
        .collection(FirebaseCollectionConst.users).where("uid", isEqualTo: uid).limit(1);

    return userCollection.snapshots().map((querySnapshot) => querySnapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList());

  }

  Stream<List<UserEntity>> getUsers() {
    final userCollection = fireStore
        .collection(FirebaseCollectionConst.users);

    return userCollection.snapshots().map((querySnapshot) => querySnapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList());



  }


  Future<void> updateUser(UserEntity user) async {
    final userCollection = fireStore
        .collection(FirebaseCollectionConst.users);

    Map<String, dynamic> userInfo = Map();

    if(user.username != "" && user.username != null) userInfo['username'] = user.username;

    userCollection.doc(user.uid).update(userInfo);
  }
}
