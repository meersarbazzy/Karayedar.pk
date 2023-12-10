import 'package:flutter/material.dart';
import 'package:karayedar_pk/screens/apartments_landlord.dart';
import 'package:karayedar_pk/screens/donateforneedy.dart';
import 'package:karayedar_pk/screens/farmhouses_landlord.dart';
import 'package:karayedar_pk/screens/houses_landlord.dart';
import 'package:karayedar_pk/screens/jazz_cash_pay.dart';
import 'package:karayedar_pk/screens/menu.dart';
import 'package:karayedar_pk/screens/others_landlord.dart';
import 'package:karayedar_pk/screens/warehouses_landlord.dart';

class LandlordHomeScreen extends StatefulWidget {
  @override
  State<LandlordHomeScreen> createState() => _LandlordHomeScreenState();
}

class _LandlordHomeScreenState extends State<LandlordHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pre-cache asset images
    precacheImage(AssetImage('assets/images/appbar_logo.png'), context);
    precacheImage(AssetImage('assets/images/donateforneedy.jpg'), context);
    precacheImage(AssetImage('assets/images/houses_category.jpg'), context);
    precacheImage(AssetImage('assets/images/apartments_category.png'), context);
    precacheImage(AssetImage('assets/images/warehouses_category.jpg'), context);
    precacheImage(AssetImage('assets/images/farmhouses_category.png'), context);
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 30),
              _buildSearchBar(),
              SizedBox(height: 30),
              ImageCardButton(
                title: 'Donate for Needy',
                imageUrl: 'assets/images/donateforneedy.jpg',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => JazzCashPage()));
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
                        MaterialPageRoute(
                            builder: (context) => AddHouseScreen()));
                  },
                ),
                secondCard: ImageCardButton(
                  title: 'Apartments',
                  imageUrl: 'assets/images/apartments_category.png',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ApartmentsPage()));
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
                            builder: (context) => WarehousesPage()));
                  },
                ),
                secondCard: ImageCardButton(
                  title: 'Farm Houses',
                  imageUrl: 'assets/images/farmhouses_category.png',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FarmhousesPage()));
                  },
                ),
              ),
              SizedBox(height: 02),
              CardButton(
                title: 'Others',
                color: Color(0xFF42210B),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OthersPage()));
                },
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
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
                decoration: InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryLabel() {
    return Text(
      'What do you want to rent?',
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildImageCardRow(
      {required ImageCardButton firstCard,
      required ImageCardButton secondCard}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: firstCard,
        ),
        SizedBox(width: 8),
        Expanded(
          child: secondCard,
        ),
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
              child: title == 'Donate for Needy'
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
                          TextSpan(text: 'Donate for '),
                          TextSpan(
                            text: 'Needy',
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
