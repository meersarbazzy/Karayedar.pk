import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:karayedar_pk/screens/apartmentslistscreen.dart';
import 'package:karayedar_pk/screens/applyfordonation.dart';
import 'package:karayedar_pk/screens/farmhouseslistscreen.dart';
import 'package:karayedar_pk/screens/houseslistscreen.dart';
import 'package:karayedar_pk/screens/menu.dart';
import 'package:karayedar_pk/screens/otherslistscreen.dart';
import 'package:karayedar_pk/screens/realtorpropertiesbyuserscreen.dart';
import 'package:karayedar_pk/screens/search_functionality.dart';
import 'package:karayedar_pk/screens/warehouselistscreen.dart';
import 'package:karayedar_pk/services/firestore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TenantHomeScreen extends StatefulWidget {
  @override
  _TenantHomeScreenState createState() => _TenantHomeScreenState();
}

class _TenantHomeScreenState extends State<TenantHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController _searchController = TextEditingController();
  bool _isLoadingSearch = false;


  List<DocumentSnapshot> _searchResults = [];
  bool _isSearching = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pre-cache asset images
    precacheImage(AssetImage('assets/images/appbar_logo.png'), context);
    precacheImage(AssetImage('assets/images/applyfordonation.jpg'), context);
    precacheImage(AssetImage('assets/images/houses_category.jpg'), context);
    precacheImage(AssetImage('assets/images/apartments_category.png'), context);
    precacheImage(AssetImage('assets/images/warehouses_category.jpg'), context);
    precacheImage(AssetImage('assets/images/farmhouses_category.png'), context);
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  Future<List<QueryDocumentSnapshot>> searchCollection(
      String collection, String query) async {
    var result = await FirebaseFirestore.instance
        .collection(collection)
        .where('address', isEqualTo: query)
        .get();

    return result.docs;
  }

  Future<void> _searchFirestore(String query) async {
    setState(() {
      _isLoadingSearch = true; // Start loading
    });

    var searchResults = await SearchFunctionality.searchFirestore(query);

    setState(() {
      _searchResults = searchResults.cast<DocumentSnapshot<Object?>>();
      _isSearching = true;
      _isLoadingSearch = false; // Stop loading
    });
  }





  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return  WillPopScope(
        onWillPop: () async {
          if (_isSearching) {
            setState(() {
              _isSearching = false; // Hide the search results
            });
            return false; // Prevents the screen from being popped
          }
          return true; // Allows the default behavior
        },
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Image.asset('assets/images/appbar_logo.png',
                width: 149, height: 23),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.menu, color: Color(0xFF42210B)),
              onPressed: _openDrawer,
            ),
            actions: [
          IconButton(
          icon: Icon(Icons.search),
          onPressed: () async {
            final query = _searchController.text.trim();
            if (query.isNotEmpty) {
              await _searchFirestore(query);
            }
          },
        )



            ],
          ),
          drawer: CustomDrawer(),
          body: _isLoadingSearch ? Center(child: CircularProgressIndicator())
              : (_isSearching ? _buildSearchResults()
              : _buildRegularUI()),
        ) );
  }

  Widget _buildSearchResults() {
    if (_isLoadingSearch) {
      return Center(child: CircularProgressIndicator());
    }
    return SearchFunctionality.buildSearchResults(_searchResults.cast<Map<String, dynamic>>(), context);
  }


  Widget _buildRegularUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 30),
            _buildSearchBar(),
            SizedBox(height: 30),
            ImageCardButton(
              title: 'Apply for Donation',
              imageUrl: 'assets/images/applyfordonation.jpg',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ApplyForDonationScreen()),
                );
              },
              width: 328,
              height: 180,
            ),
            SizedBox(height: 30),
            _buildCategoryLabel(),
            SizedBox(height: 30),
            _buildImageCardRow(
              firstCard: ImageCardButton(
                title: 'Houses',
                imageUrl: 'assets/images/houses_category.jpg',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HousesListScreen()),
                  );
                },
              ),
              secondCard: ImageCardButton(
                title: 'Apartments',
                imageUrl: 'assets/images/apartments_category.png',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ApartmentsListScreen()),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            _buildImageCardRow(
              firstCard: ImageCardButton(
                title: 'Warehouses',
                imageUrl: 'assets/images/warehouses_category.jpg',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WarehousesListScreen()),
                  );
                },
              ),
              secondCard: ImageCardButton(
                title: 'Farm Houses',
                imageUrl: 'assets/images/farmhouses_category.png',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FarmhousesListScreen()),
                  );
                },
              ),
            ),
            SizedBox(height: 02),
            CardButton(
              title: 'Others',
              color: Color(0xFF42210B),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OthersListScreen()),
                );
              },
            ),
            SizedBox(height: 30),

            // Realtor Properties Heading
            _buildRealtorPropertiesHeading(),

            SizedBox(height: 30),

            // Realtor Properties Image Card Button
            ImageCardButton(
              title: 'Realtor Properties',
              imageUrl: 'assets/images/realtor_properties_placeholder.jpg', // Placeholder image
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RealtorPropertiesByUserScreen()),
                );
              },
              width: double.infinity,
              height: 180,
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
  Widget _buildRealtorPropertiesHeading() {
    return Text(
      'Realtor Properties',
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
    );
  }
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Color(0xFF42210B),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(Icons.search),
            SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
                onFieldSubmitted: (String value) async {
                  // This is triggered when the user submits the field
                  await _searchFirestore(value.trim());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildCategoryLabel() {
    return Text(
      'What are you looking for?',
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildImageCardRow({
    required ImageCardButton firstCard,
    required ImageCardButton secondCard,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: firstCard),
        SizedBox(width: 8),
        Expanded(child: secondCard),
      ],
    );
  }
}

class ImageCardButton extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onPressed;
  final double width;
  final double height;

  ImageCardButton({
    required this.title,
    required this.imageUrl,
    required this.onPressed,
    this.width = 172, // Default value from the original ImageCardButton
    this.height = 152, // Default value from the original ImageCardButton
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19.2),
        border: Border.all(
          color: Color(0xFF42210B),
          width: 1.8,
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(17),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.6),
                BlendMode.darken,
              ),
              child: Material(
                child: InkWell(
                  onTap: onPressed,
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: title == 'Apply for Donation'
                  ? RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  children: [
                    TextSpan(text: 'Apply for '),
                    TextSpan(
                      text: 'Donation',
                      style: TextStyle(color: Colors.yellow),
                    ),
                  ],
                ),
              )
                  : Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardButton extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onPressed;

  CardButton(
      {required this.title, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _showHousesList(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('houses').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Precache images
          for (var doc in snapshot.data!.docs) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            precacheImage(NetworkImage(data['imageURL']), context);
          }
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> data =
              snapshot.data!.docs[index].data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    // Navigate to a detailed view if needed
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: CachedNetworkImage(
                          imageUrl: data['imageURL'],
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                      ),
                      ListTile(
                          title: Text(data['address'])),
                      SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['address'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Monthly Rent: ${data['monthlyRent'].toString()}',
                              style: TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                            // Add more fields as needed
                          ],
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
    },
  );
}