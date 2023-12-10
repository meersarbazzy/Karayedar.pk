import 'package:equatable/equatable.dart';

class HouseEntity extends Equatable {
  final String? address;
  final String? areaSize;
  final String? areaType;
  final String? monthlyRent;
  final String? currency;
  final String? propertyDescription;
  final String? email;
  final String? phoneNumber;
  final String? imageUrl; // This was inferred from the Firebase Storage code
  final DateTime? timestamp; // This was inferred from your _postAd function

  HouseEntity({
    this.address,
    this.areaSize,
    this.areaType,
    this.monthlyRent,
    this.currency,
    this.propertyDescription,
    this.email,
    this.phoneNumber,
    this.imageUrl,
    this.timestamp,
  });

  @override
  List<Object?> get props => [
        address,
        areaSize,
        areaType,
        monthlyRent,
        currency,
        propertyDescription,
        email,
        phoneNumber,
        imageUrl,
        timestamp,
      ];
}
