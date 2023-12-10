import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:karayedar_pk/screens/house_list_screen_details.dart';
import 'package:karayedar_pk/screens/others_list_screen.dart';
import 'package:karayedar_pk/screens/propertydetailsscreen.dart';
import 'package:karayedar_pk/screens/warehouses_list_screen.dart';
import 'package:karayedar_pk/screens/apartments_list_screen.dart';
import 'package:karayedar_pk/screens/farmhouses_list_screen.dart';
// Import other detail screens as needed

class SearchFunctionality {
  static Future<List<Map<String, dynamic>>> searchFirestore(String query) async {
    if (query.isEmpty) {
      return [];
    }

    List<String> collections = [
      'houses',
      'warehouses',
      'farmhouses',
      'apartments',
      'otherProperties'
      'realtorProperties',
    ];

    List<Map<String, dynamic>> combinedResults = [];

    for (String collection in collections) {
      var result = await FirebaseFirestore.instance
          .collection(collection)
          .where('address', isEqualTo: query)
          .get();

      for (var doc in result.docs) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add the document's ID
        data['category'] = collection; // Add the collection name as 'category'
        combinedResults.add(data);
      }
    }

    return combinedResults;
  }

  static Widget buildSearchResults(List<Map<String, dynamic>> searchResults, BuildContext context) {
    if (searchResults.isEmpty) {
      return Center(
        child: Text(
          'No results found',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final data = searchResults[index];
        final String category = data['category'] ?? 'Unknown Category';
        final List<String> imageUrls = (data['imageUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [];

        String? displayImageUrl;
        if (imageUrls.isNotEmpty) {
          displayImageUrl = imageUrls[0]; // Use the first image URL for display
        }

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 5,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: InkWell(
            onTap: () {
              if (category == 'houses') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HousesListScreenDetails(data: data)));
              } else if (category == 'warehouses') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => WarehousesListScreenDetails(data: data)));
              } else if (category == 'farmhouses') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FarmhousesListScreenDetails(data: data)));
              } else if (category == 'apartments') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ApartmentsListScreenDetails(data: data)));
              } else if (category == 'otherProperties') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => OthersPropertyDetailsScreen(data: data)));
              }
              else if (category == 'realtorProperties') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PropertyDetailsPage(data: data)));
              }
              // Add more categories if necessary
            },
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  displayImageUrl != null
                      ? CachedNetworkImage(
                    imageUrl: displayImageUrl,
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                    placeholder: (context, url) => Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: Center(child: Icon(Icons.error)),
                    ),
                  )
                      : Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: Center(child: Text('No Image Available')),
                  ),
                  SizedBox(height: 10),
                  Text(
                    data['address'] ?? 'No Address',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Category: $category',
                    style: TextStyle(fontSize: 14, color: Colors.green[700], fontWeight: FontWeight.w600),
                  ),
                  if (category == 'realtorProperties')
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Property by Agent',
                        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                    ),
                  // Add more details as needed
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}