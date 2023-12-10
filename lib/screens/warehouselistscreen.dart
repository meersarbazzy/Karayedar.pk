import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:karayedar_pk/screens/warehouses_list_screen.dart';

class WarehousesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Warehouses"),
        backgroundColor:
            Colors.green[800], // Set the AppBar color to green[800]
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0), // Set padding to 18
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('warehouses').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            // Extract the list of documents from the snapshot
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

                // Explicitly add the document's ID to the data map
                data['id'] = documents[index].id;

                List<String>? imageUrls =
                    data['imageUrls']?.cast<String>() ?? [];
                return ImageCardButton(
                  title: data['address'] ?? 'No Address',
                  imageUrls: imageUrls, // Pass the list of image URLs here
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WarehousesListScreenDetails(
                          data: data,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// ImageCardButton remains the same as in your previous screens

class ImageCardButton extends StatelessWidget {
  final String title;
  final List<String>? imageUrls; // Accept a list of image URLs
  final VoidCallback onPressed;

  ImageCardButton({
    required this.title,
    this.imageUrls,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    String? imageUrl = imageUrls?.isNotEmpty == true ? imageUrls![0] : null;

    return GestureDetector(
      onTap: onPressed,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              17.0), // Set the Card's border radius to 17.0
        ),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                // Wrap the Stack with a ClipRRect
                borderRadius: BorderRadius.circular(
                    17.0), // Set the ClipRRect's border radius to 17.0
                child: Stack(
                  children: [
                    imageUrl != null
                        ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error),
                    )
                        : Container(color: Colors.red[200]),
                    // This is your gradient overlay
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.black54],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    // This is your text
                    Positioned(
                      bottom: 10.0,
                      left: 10.0,
                      right: 10.0,
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
