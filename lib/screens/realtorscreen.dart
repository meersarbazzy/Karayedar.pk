import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:karayedar_pk/screens/bulkuploadscreen.dart';
import 'package:karayedar_pk/screens/propertydetailsscreen.dart';

class RealtorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF42210B)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Image.asset('assets/images/appbar_logo.png', width: 149, height: 23),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Color(0xFF42210B)),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => BulkUploadScreen()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Realtor Dashboard',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: RealtorPropertiesList()),
          ],
        ),
      ),
    );
  }
}

class RealtorPropertiesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid; // Get current user's ID

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('realtorProperties')
          .snapshots(), // Removed the .where filter
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final documents = snapshot.data!.docs;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 8, // Set spacing to 18
            mainAxisSpacing: 18, // Set spacing to 18
          ),
          itemCount: documents.length,
          itemBuilder: (BuildContext context, int index) {
            // Extract data as a Map
            Map<String, dynamic> data =
            documents[index].data() as Map<String, dynamic>;
            // Extract data as a Map and Explicitly add the document's ID to the data map
            data['id'] = documents[index].id;
            var propertyId = documents[index].id; // Get the property ID


            List<String>? imageUrls =
                data['imageUrls']?.cast<String>() ?? [];


            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 4,
              margin: EdgeInsets.all(8),
              child: InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PropertyDetailsPage(data: data))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                        child: Image.network(
                          imageUrls!.isNotEmpty ? imageUrls[0] : 'https://via.placeholder.com/200', // Placeholder image
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                            return Icon(Icons.error); // Display error icon if the image fails to load
                          },
                        ),
                      ),
                    ),

                    ListTile(
                      title: Text(data['address'] ?? 'No Address', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${data['propertyType']?.toUpperCase() ?? 'N/A'}", style: TextStyle(fontSize: 14, color: Colors.green[700], fontWeight: FontWeight.w600),),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteProperty(context, propertyId),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
          },
    );
  }

  void _deleteProperty(BuildContext context, String? propertyId) {
    if (propertyId != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirm Deletion"),
            content: Text("Are you sure you want to delete this property?"),
            actions: <Widget>[
              TextButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text("Delete"),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('realtorProperties')
                      .doc(propertyId)
                      .delete();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
