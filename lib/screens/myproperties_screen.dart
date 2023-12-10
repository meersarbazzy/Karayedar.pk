import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Add the UpdatePropertyScreen here (similar to the existing property creation screen but for updates)

class MyPropertiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Properties"),
        centerTitle: true,
        backgroundColor: Colors.green[800],
      ),
      body: UserProperties(),
    );
  }
}

class UserProperties extends StatefulWidget {
  @override
  State<UserProperties> createState() => _UserPropertiesState();
}

class _UserPropertiesState extends State<UserProperties> {
  late Future<List<Map<String, dynamic>>> propertiesFuture;

  @override
  void initState() {
    super.initState();
    propertiesFuture = fetchAllProperties();
  }

  Future<void> deleteProperty(BuildContext context, String collectionName, String docId) async {
    // Show confirmation dialog
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete this property?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    ) ?? false;

    if (confirm) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      // Delete the property
      await FirebaseFirestore.instance.collection(collectionName).doc(docId).delete();
      Navigator.pop(context); // Close the loading indicator

      // Refresh the list
      setState(() {
        propertiesFuture = fetchAllProperties();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: propertiesFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.data!.isEmpty) {
          return Center(child: Text('No Properties Found'));
        }

        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            var data = snapshot.data![index];
            List<dynamic> imageUrls = data['imageUrls'] ?? [];
            String firstImageUrl = imageUrls.isNotEmpty ? imageUrls[0] : '';

            return Card(
              margin: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  firstImageUrl.isNotEmpty
                      ? CachedNetworkImage(
                    imageUrl: firstImageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      height: 200,
                      child: Center(child: Icon(Icons.error)),
                    ),
                  )
                      : Container(color: Colors.grey[200], height: 200),
                  ListTile(
                    title: Text(data['address'] ?? 'No Address'),
                    subtitle: Text('Category: ${data['type'].toString().capitalize()}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdatePropertyScreen(propertyData: data),
                              ),
                            ).then((_) {
                              setState(() {
                                propertiesFuture = fetchAllProperties();
                              });
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => deleteProperty(context, data['type'], data['id']),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

Future<List<Map<String, dynamic>>> fetchAllProperties() async {
  List<String> collections = [
    'houses', 'warehouses', 'farmhouses', 'apartments', 'otherProperties', 'realtorProperties'
  ];
  List<Map<String, dynamic>> allProperties = [];
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  if (currentUserId == null) {
    print("User is not logged in");
    return []; // Return an empty list if no user is logged in
  }

  print("Current User ID: $currentUserId"); // Debugging statement

  try {
    for (String collection in collections) {
      var result = await FirebaseFirestore.instance
          .collection(collection)
          .where('userId', isEqualTo: currentUserId)
          .get();

      print("Found ${result.docs.length} properties in $collection for user $currentUserId"); // Debugging statement

      for (var doc in result.docs) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        data['type'] = collection;
        allProperties.add(data);
      }
    }
  } catch (e) {
    print("Error fetching properties: $e"); // Error handling
  }

  return allProperties;
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
class UpdatePropertyScreen extends StatelessWidget {
  final Map<String, dynamic> propertyData;

  UpdatePropertyScreen({required this.propertyData});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}