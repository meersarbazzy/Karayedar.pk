import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HouseDetailScreen extends StatelessWidget {
  final String houseId;

  HouseDetailScreen({required this.houseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('House Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('houses').doc(houseId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading house details'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No house details found'));
          }
          final houseData = snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'House Details',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 20),
                Text('Address: ${houseData['address']}'),
                Text('Price: ${houseData['price']}'),
                Text('Description: ${houseData['description']}'),
                // Add more fields as you expand your Firestore structure.
              ],
            ),
          );
        },
      ),
    );
  }
}
