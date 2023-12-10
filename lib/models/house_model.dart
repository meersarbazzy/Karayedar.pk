import 'package:karayedar_pk/entities/entity.dart';

class HouseModel extends HouseEntity {
  HouseModel({
    String? address,
    String? areaSize,
    String? areaType,
    String? monthlyRent,
    String? currency,
    String? propertyDescription,
    String? email,
    String? phoneNumber,
    String? imageUrl,
    DateTime? timestamp,
  }) : super(
          address: address,
          areaSize: areaSize,
          areaType: areaType,
          monthlyRent: monthlyRent,
          currency: currency,
          propertyDescription: propertyDescription,
          email: email,
          phoneNumber: phoneNumber,
          imageUrl: imageUrl,
          timestamp: timestamp,
        );

  // Converts HouseModel to a Map for Firestore
  Map<String, dynamic> toDocument() {
    return {
      'address': address,
      'areaSize': areaSize,
      'areaType': areaType,
      'monthlyRent': monthlyRent,
      'currency': currency,
      'propertyDescription': propertyDescription,
      'email': email,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'timestamp': timestamp
          ?.millisecondsSinceEpoch, // Firestore uses milliseconds for DateTime
    };
  }

  // Converts a Firestore Map to a HouseModel
  static HouseModel fromDocument(Map<String, dynamic> doc) {
    return HouseModel(
      address: doc['address'] as String?,
      areaSize: doc['areaSize'] as String?,
      areaType: doc['areaType'] as String?,
      monthlyRent: doc['monthlyRent'] as String?,
      currency: doc['currency'] as String?,
      propertyDescription: doc['propertyDescription'] as String?,
      email: doc['email'] as String?,
      phoneNumber: doc['phoneNumber'] as String?,
      imageUrl: doc['imageUrl'] as String?,
      timestamp: doc['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(doc['timestamp'] as int)
          : null,
    );
  }
}
