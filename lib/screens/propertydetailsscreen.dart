import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karayedar_pk/chat/chat/single_chat_page.dart';
import 'package:karayedar_pk/chat/data_sources/firebase_remote_datasouce.dart';
import 'package:karayedar_pk/models/review_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:karayedar_pk/user/data/remote_data_source/firebase_remote_data_source_impl.dart';
import '../chat/communication/communication_cubit.dart';
import '../chat/data_sources/firebase_remote_datasource_impl.dart';

class PropertyDetailsPage extends StatefulWidget {
  final Map<String, dynamic> data;

  PropertyDetailsPage({Key? key, required this.data}) : super(key: key);

  @override
  _PropertyDetailsPageState createState() => _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final db = UserFirebaseRemoteDataSourceImpl();
  final dbChat = FirebaseRemoteRepositoryImpl();


  void _showFullImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Image Preview'),
            backgroundColor: Colors.green[800],
          ),
          body: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Image.network(
              imageUrl,
              errorBuilder: (context, error, stackTrace) {
                return Center(child: Text('Error: Could not load image.'));
              },
            ),
          ),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    print('Received UID in PropertyDetailsPage: ${widget.data['uid']}');


/*
    List<String> imageUrls = widget.data['imageUrls']?.cast<String>() ?? [];
*/


    print('Data received in Propertyscreendetails: ${widget.data}');
/*
    print("imageUrls: $imageUrls");
*/
    /*String? displayImageUrl;
    if (imageUrls.isNotEmpty) {
      displayImageUrl = imageUrls[0]; // Use the first image URL for display
    }
*/
    String? ownerUserId = widget.data['ownerUserId']; // Retrieve owner's userId

    String address = widget.data['address'] as String? ?? 'No Address Provided';
    String areaSize = widget.data['areaSize'] as String? ?? 'Not Available';
    String monthlyRent = widget.data['monthlyRent'] as String? ?? 'Not Available';
    String description = widget.data['description'] as String? ?? 'No Description Available';
    String email = widget.data['email'] as String? ?? 'No Email Provided';
    String phone = widget.data['phone'] as String? ?? 'No Phone Number';
    List<String> imageUrls = (widget.data['imageUrls'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text("Properties"),
        backgroundColor: Colors.green[800],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18.0),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: PageView.builder(
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _showFullImage(context, imageUrls[index]),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(17.0),
                      child: Image.network(
                        imageUrls[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(color: Colors.grey[200]);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 18.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Property Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(color: Colors.green[800]),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.green[800]),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'Address: ${widget.data['address'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.aspect_ratio, color: Colors.green[800]),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'Area Size: ${widget.data['areaSize'] ?? 'N/A'} ${widget.data['areaType'] ?? ''}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.attach_money, color: Colors.green[800]),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'Monthly Rent: ${widget.data['currency'] ?? ''} ${widget.data['monthlyRent'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.description, color: Colors.green[800]),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'Description: ${widget.data['propertyDescription'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.email, color: Colors.green[800]),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'Email: ${widget.data['email'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.phone, color: Colors.green[800]),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'Phone Number: ${widget.data['phoneNumber'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          StreamBuilder<double>(
            stream: getAverageRating(
                widget.data['id']), // assuming 'id' holds the propertyId
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data == 0) {
                return Text('No reviews yet');
              } else {
                return averageRatingCard(snapshot.data!);
              }
            },
          ),
          ElevatedButton(
            child: Text('Write a Review'),
            onPressed: () {
              // Check if the property ID is valid before attempting to show the review dialog
              if (widget.data['id'] == null || !(widget.data['id'] is String)) {
                // Handle the case where the ID is null or not a string, maybe show an error or log this issue
                print("Property ID is null or not a string");
              } else {
                var propertyId = widget.data['id'] as String;
                _showReviewDialog(context,
                    propertyId); // pass the property's ID to the method
              }
            },
          ),
          Container(
            height: 200,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('reviews')
                  .where('propertyId', isEqualTo: widget.data['id'])
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var reviewData = snapshot.data!.docs[index].data()
                    as Map<String, dynamic>;
                    var review = Review.fromMap(
                        reviewData, snapshot.data!.docs[index].id);
                    return ListTile(
                      title: Text(review.comment),
                      subtitle: Text('Rating: ${review.rating}'),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            child:           _buildChatButton(),

          )
        ],
      ),
    );
  }
  Widget _buildChatButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: InkWell(
          onTap: () async {
            try {
              final String? uid = FirebaseAuth.instance.currentUser?.uid;
              final String? otherUid = widget.data['ownerUserId']; //

              print('Current UID: $uid');
              print('Other UID: $otherUid');

              if (uid == null || otherUid == null) {
                print('Error: uid or otherUid is null.');
                return;
              }

              print('Creating chat channel...');
              await BlocProvider.of<CommunicationCubit>(context).createChatChannel(
                  engageUserEntity: EngageUserEntity(uid: uid, otherUid: otherUid)
              );

              print('Fetching other user...');
              final otherUser = await db.getSingleUserFuture(otherUid!);

              if (otherUser.isEmpty) {
                print('Error: Other user not found.');
                return;
              }

              print('Creating one-to-one chat channel...');
              final String? channelId = await dbChat.createOneToOneChatChannel(
                  EngageUserEntity(uid: uid, otherUid: otherUid)
              );

              if (channelId == null) {
                print('Error: Failed to create chat channel.');
                return;
              }

              print('Navigating to SingleChatPage...');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => SingleChatPage(
                        otherUser: otherUser.first,
                        uid: uid,
                        channalId: channelId,
                        otherUId: otherUser.first.uid!,
                      )
                  )
              );
            } catch (e) {
              print('Error occurred in chat button tap: $e');
            }
          },
    child: Container(
    height: 55,
    width: double.infinity,
    alignment: Alignment.center,
    decoration: BoxDecoration(
    color: Colors.green[800],
    borderRadius: BorderRadius.circular(50),
    ),
    child: Text(
    "Chat",
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    ),
    ),
        ),
      ),
      )
    );
  }


  Widget _buildImageGallery(List<String> imageUrls) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: PageView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _showFullImage(context, imageUrls[index]),
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5.0,
                    spreadRadius: 1.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(17.0),
                child: Image.network(
                  imageUrls[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: Colors.grey[200]);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPropertyDetails() {
    // Safely access properties from widget.data
    String address = widget.data['address'] as String? ?? 'No Address';
    String areaSize = widget.data['areaSize'] as String? ?? 'N/A';
    String monthlyRent = widget.data['monthlyRent'] as String? ?? 'N/A';
    String description = widget.data['description'] as String? ?? 'N/A';
    String email = widget.data['email'] as String? ?? 'N/A';
    String phone = widget.data['phone'] as String? ?? 'N/A';


    return Column(
      children: [
        _detailTile('Address', Icons.location_on, widget.data['address'] ?? 'No Address'),
        _detailTile('Area Size', Icons.aspect_ratio, widget.data['areaSize'] ?? 'N/A'),
        _detailTile('Monthly Rent', Icons.attach_money, widget.data['monthlyRent'] ?? 'N/A'),
        _detailTile('Description', Icons.description, widget.data['description'] ?? 'N/A'),
        _detailTile('Email', Icons.email, widget.data['email'] ?? 'N/A'),
        _detailTile('Phone Number', Icons.phone, widget.data['phone'] ?? 'N/A'),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        children: [
          Text(
            "Reviews",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          _reviewsSection(widget.data['id']),
        ],
      ),
    );
  }

  Widget _buildAddReviewButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: () => _showReviewDialog(context, widget.data['id']),
        child: Text("Add Review"),
        style: ElevatedButton.styleFrom(
          primary: Colors.green[800],
        ),
      ),
    );
  }
  Widget _detailTile(String title, IconData icon, String? value) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value ?? 'N/A'),
    );
  }

  Widget _reviewsSection(String propertyId) {
    return StreamBuilder<List<Review>>(
      stream: _getReviews(propertyId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return Column(
          children: snapshot.data!.map((Review review) {
            return ListTile(
              title: Text(review.comment),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  );
                }),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Stream<List<Review>> _getReviews(String propertyId) {
    return FirebaseFirestore.instance
        .collection('reviews')
        .where('propertyId', isEqualTo: propertyId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Review.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList());
  }

  Future<void> _showReviewDialog(
      BuildContext context, String propertyId) async {
    String? comment;
    double localRating = 0; // Local rating for the dialog

    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            // <-- This is crucial for updating the state of the content within the dialog
              builder: (context, setState) {
                return AlertDialog(
                  title: Text('Write a Review'),
                  content: SingleChildScrollView(
                    // This prevents overflow issues
                    child: ListBody(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Your review',
                            border: OutlineInputBorder(), // Enhanced UI
                          ),
                          maxLines: 2, // Allows multiple lines
                          onChanged: (value) {
                            comment = value;
                          },
                        ),
                        SizedBox(height: 16),
                        Text('Rating:'),
                        // Star rating
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(5, (index) {
                            return IconButton(
                              icon: Icon(
                                index < localRating
                                    ? Icons.star
                                    : Icons.star_border,
                                color:
                                Colors.green[800], // Use your theme color here
                              ),
                              onPressed: () {
                                // Update the rating state
                                setState(() {
                                  // This setState is provided by StatefulBuilder
                                  localRating = index + 1.0;
                                });
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Submit'),
                      onPressed: () {
                        if (localRating > 0 && comment?.isNotEmpty == true) {
                          // Ensure you check localRating, not rating
                          // Get the userId from wherever it's stored (e.g., a user management system)
                          String userId = FirebaseAuth.instance.currentUser!
                              .uid; // Retrieve the actual user ID

                          // Create a new Review instance with the userId
                          Review newReview = Review(
                            id: '', // You should generate a unique ID here or let the database do it
                            propertyId:
                            propertyId, // this should be the actual property ID
                            userId: userId, // set userId here
                            rating: localRating, // Use localRating here
                            comment: comment!,
                            date: DateTime.now(),
                          );
                          addReview(newReview); // Use the addReview method
                          Navigator.of(context).pop(); // Close the dialog
                        } else {
                          // Show validation error
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please give a rating and comment.'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                );
              });
        });
  }
  Future<void> addReview(Review review) async {
    try {
      // Get the current user's ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Add the user's ID to the review

      // Add the review to Firestore
      await FirebaseFirestore.instance
          .collection('reviews')
          .add(review.toMap());
    } catch (e) {
      // Handle any errors, e.g., by showing a dialog or printing to the console
      print("An error occurred while adding the review: $e");
    }
  }

  Stream<List<Review>> getReviews(String propertyId) {
    return FirebaseFirestore.instance
        .collection('reviews')
        .where('propertyId', isEqualTo: propertyId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Review.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    }).handleError((e) {
      // Handle any errors, e.g., by showing a dialog or printing to the console
      print("An error occurred while fetching reviews: $e");
    });
  }

  Stream<double> getAverageRating(String propertyId) {
    return FirebaseFirestore.instance
        .collection('reviews')
        .where('propertyId', isEqualTo: propertyId)
        .snapshots()
        .map((snapshot) {
      double totalRating = 0.0;
      snapshot.docs.forEach((doc) {
        totalRating += (doc.data() as Map<String, dynamic>)['rating'];
      });
      return totalRating / snapshot.docs.length; // returns average rating
    }).handleError((e) {
      print("An error occurred while fetching reviews: $e");
      return 0.0; // return 0 on error
    });
  }

  Widget averageRatingCard(double rating) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, color: Colors.green[800], size: 24),
            SizedBox(width: 10),
            Text(
              rating.toStringAsFixed(1), // to display one digit after decimal
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


