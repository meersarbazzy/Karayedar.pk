import 'package:cloud_firestore/cloud_firestore.dart';

class House {
  final String id;
  final String address;
  final String areaSize;
  final String areaType;
  final String monthlyRent;
  final String currency;
  final String description;
  final String email;
  final String phoneNumber;
  final List<String> imageUrls;

  House({
    required this.id,
    required this.address,
    required this.areaSize,
    required this.areaType,
    required this.monthlyRent,
    required this.currency,
    required this.description,
    required this.email,
    required this.phoneNumber,
    required this.imageUrls,
  });

  factory House.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return House(
      id: doc.id,
      address: data['address'],
      areaSize: data['areaSize'],
      areaType: data['areaType'],
      monthlyRent: data['monthlyRent'],
      currency: data['currency'],
      description: data['description'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      imageUrls:
          List<String>.from(data['imageUrls'] ?? []), // Use null-aware operator
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'address': address,
      'areaSize': areaSize,
      'areaType': areaType,
      'monthlyRent': monthlyRent,
      'currency': currency,
      'description': description,
      'email': email,
      'phoneNumber': phoneNumber,
      'imageUrls': imageUrls,
    };
  }
}
