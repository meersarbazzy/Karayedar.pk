import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:karayedar_pk/house.dart';

class FirestoreService {
  final CollectionReference housesCollection =
      FirebaseFirestore.instance.collection('houses');

  Stream<List<House>> getHouses() {
    return housesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => House.fromFirestore(doc)).toList();
    });
  }

  Stream<QuerySnapshot> getRecentHouses() {
    return housesCollection.snapshots();
  }

  Stream<QuerySnapshot> getLatestHouseImageUrl() {
    return FirebaseFirestore.instance
        .collection('houses')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots();
  }
}
