import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String? id; // unique id of the review document, now nullable
  final String propertyId; // id of the property this review is about
  late final String userId; // id of the user who wrote the review
  final double rating; // rating for the property
  final String comment; // review comment
  final DateTime date; // date of the review

  Review({
    this.id, // this is now optional
    required this.propertyId,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.date,
  });

  // Named constructor to create a Review instance from a map
  factory Review.fromMap(Map<String, dynamic> map, String documentId) {
    return Review(
      id: documentId,
      propertyId: map['propertyId'],
      userId: map['userId'],
      rating: map['rating'],
      comment: map['comment'],
      date: (map['date'] as Timestamp)
          .toDate(), // converting Timestamp to DateTime
    );
  }

  // Method to convert a Review instance into a map
  Map<String, dynamic> toMap() {
    // We don't include 'id' here since it's managed by Firestore
    return {
      'propertyId': propertyId,
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'date': date,
    };
  }
}
