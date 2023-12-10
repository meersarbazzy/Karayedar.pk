import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:karayedar_pk/screens/propertydetailsscreen.dart';
class RealtorPropertiesByUserScreen extends StatefulWidget {
  @override
  _RealtorPropertiesByUserScreenState createState() => _RealtorPropertiesByUserScreenState();
}

class _RealtorPropertiesByUserScreenState extends State<RealtorPropertiesByUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: Text("Realtors"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('realtorProperties').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error loading properties"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No properties found"));
          }

          // Extract unique user IDs from properties
          Set<String> userIds = snapshot.data!.docs
              .map((doc) {
            final data = doc.data() as Map<String, dynamic>?;

            if (data != null && data.containsKey('userId')) {
              return data['userId'] as String?;
            }

            return null;
          })
              .where((userId) => userId != null)
              .cast<String>()
              .toSet();




          return ListView.builder(
            itemCount: userIds.length,
            itemBuilder: (context, index) {
              String userId = userIds.elementAt(index);

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(title: Text("Loading user data..."));
                  }
                  if (userSnapshot.hasError) {
                    return ListTile(title: Text("Error loading user data"));
                  }
                  if (!userSnapshot.hasData || userSnapshot.data!.data() == null) {
                    return ListTile(title: Text("User not found"));
                  }

                  var userData = userSnapshot.data!.data() as Map<String, dynamic>;
                  String profileImageUrl = userData['profileImageUrl'] ?? 'default_image_url';
                  String userName = userData['name'] ?? 'Unknown User';
                  String userEmail = userData['email'] ?? 'No Email';

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(profileImageUrl),
                    ),
                    title: Text(userName),
                    subtitle: Text(userEmail),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserPropertiesScreen(userId: userId)),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}



class UserPropertiesScreen extends StatelessWidget {
  final String userId;
  UserPropertiesScreen({required this.userId});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: Text("User's Properties"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('realtorProperties')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No properties found for this user"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var propertyDoc = snapshot.data!.docs[index];
              var property = propertyDoc.data() as Map<String, dynamic>;
              var propertyId = propertyDoc.id;

              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PropertyDetailsPage(data: {
                        ...property,
                        'id': propertyId,
                        'ownerUserId': userId,
                      }),
                    ),
                  );
                },
                child: PropertyCard(property: property),
              );
            },
          );
        },
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final Map<String, dynamic> property;

  PropertyCard({required this.property});

  @override
  Widget build(BuildContext context) {
    String address = property['address'] ?? 'No Address';
    String description = property['description'] ?? 'No Description';
    List<String> imageUrls = List.from(property['imageUrls'] ?? []);
    String propertyType = property['propertyType'] ?? 'Not specified';

    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image section
          ImageSection(imageUrls: imageUrls),
          // Property details section
          Padding(
            padding: EdgeInsets.all(10.0),
            child: PropertyDetails(
              address: address,
              propertyType: propertyType,
              description: description,
            ),
          ),
        ],
      ),
    );
  }
}

class ImageSection extends StatelessWidget {
  final List<String> imageUrls;

  ImageSection({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return (imageUrls.isNotEmpty && imageUrls.first != null)
        ? Image.network(
      imageUrls.first,
      fit: BoxFit.cover,
      height: 200.0,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: 200.0,
          color: Colors.grey[300],
          child: Icon(Icons.broken_image, size: 60.0, color: Colors.grey[600]),
        );
      },
    )
        : Container(
      height: 200.0,
      color: Colors.grey[300],
      child: Icon(Icons.image, size: 60.0, color: Colors.grey[600]),
    );
  }
}

class PropertyDetails extends StatelessWidget {
  final String address;
  final String propertyType;
  final String description;

  PropertyDetails({required this.address, required this.propertyType, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          address,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          'Type: $propertyType',
          style: TextStyle(fontSize: 14, color: Colors.green[700], fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 5.0),
        Text(
          description,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
