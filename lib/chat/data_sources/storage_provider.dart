

import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class StorageProviderRemoteDataSource{


  static FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String> uploadFile({required File file}) async {
    final ref = _storage.ref().child(
        "Documents/${DateTime.now().millisecondsSinceEpoch}${getNameOnly(file.path)}");
    print("file ${file.path}");

    final uploadTask = ref.putFile(file);

    final imageUrl= (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
   return await imageUrl;
  }


  static Future<String> uploadBytes({required Uint8List data}) async {
    final ref = _storage.ref().child(
        "signatures/${DateTime.now().millisecondsSinceEpoch}");

    final uploadTask = ref.putData(data);

    final imageUrl= (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return await imageUrl;
  }


  static String getNameOnly(String path) {
    return path.split('/').last.split('%').last.split("?").first;
  }
}