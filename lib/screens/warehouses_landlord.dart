import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:karayedar_pk/screens/landlord_homescreen.dart';
import 'package:karayedar_pk/screens/menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:karayedar_pk/screens/myproperties_screen.dart';

class WarehousesPage extends StatefulWidget {
  @override
  _WarehousesPageState createState() => _WarehousesPageState();
}

class _WarehousesPageState extends State<WarehousesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedAreaType = 'ft';
  String _selectedCurrency = 'PKR';
  List<XFile> _selectedImages = [];
  TextEditingController _addressController = TextEditingController();
  TextEditingController _areaSizeController = TextEditingController();
  TextEditingController _monthlyRentController = TextEditingController();
  TextEditingController _propertyDescriptionController =
      TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  void _uploadPictures() async {
    final pickedFiles = await ImagePicker().pickMultiImage(
      imageQuality: 50, // you might want to adjust these
      maxWidth: 800, // you might want to adjust these
    );
    if (pickedFiles != null) {
      setState(() {
        _selectedImages.addAll(pickedFiles);
      });
    }
  }
  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _postAd() async {
    try {
      // Show a loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(),
                new Text("Uploading..."),
              ],
            ),
          );
        },
      );

      // Prepare data to be saved in Firestore
      final warehouseData = {
        'address': _addressController.text,
        'areaSize': _areaSizeController.text,
        'areaType': _selectedAreaType,
        'monthlyRent': _monthlyRentController.text,
        'currency': _selectedCurrency,
        'propertyDescription': _propertyDescriptionController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneNumberController.text,
        'timestamp':
            Timestamp.fromDate(DateTime.now()), // Firestore's timestamp
        'userId': FirebaseAuth.instance.currentUser?.uid, // Add this line

        // Add other fields as necessary
      };

      // Reference to Firestore collection
      final collectionRef = FirebaseFirestore.instance.collection('warehouses');

      // Add a new document and get the document ID
      final documentReference = await collectionRef.add(warehouseData);
      final warehouseId = documentReference.id;

      // List to hold download URLs from Firebase Storage
      List<String> imageUrls = [];

      // Upload images to Firebase Storage
      for (int i = 0; i < _selectedImages.length; i++) {
        // Reference to the storage location
        final storageRef =
            FirebaseStorage.instance.ref('warehouses/$warehouseId/image$i');

        // Upload the file
        await storageRef.putFile(File(_selectedImages[i].path));

        // Retrieve the download URL
        final imageUrl = await storageRef.getDownloadURL();

        // Add the URL to the list
        imageUrls.add(imageUrl);
      }

      // Update the document in Firestore with the image URLs
      await collectionRef.doc(warehouseId).update({'imageUrls': imageUrls});

      // Dismiss the loading indicator
      Navigator.pop(context);

      // Show the success dialog
      _showPostAdDialog(context);
    } catch (e) {
      // Dismiss the loading indicator
      Navigator.pop(context);

      // Log error and inform the user
      print('An error occurred while uploading: $e');
      // You can show a dialog or snackbar with the error message
    }
  }

  InputDecoration _decoratedTextField(String labelText,
      {IconData? iconData, String? prefixText}) {
    return InputDecoration(
      labelText: labelText,
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      prefixIcon: iconData != null ? Icon(iconData, color: Colors.grey) : null,
      prefixText: prefixText,
    );
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
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Warehouse',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 20),

              TextField(
                decoration:
                    _decoratedTextField('Address', iconData: Icons.location_on),
              ),
              SizedBox(height: 10),

              // Image Upload & Preview
              ImageUploadPreview(
                selectedImages: _selectedImages,
                onImageUpload: _uploadPictures,
                onImageRemove: _removeImage,
              ),
              SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: _decoratedTextField('Area Size',
                          iconData: Icons.home),
                    ),
                  ),
                  SizedBox(width: 10),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedAreaType,
                      items: [
                        'ft',
                        'yard',
                        'sq ft',
                        'sq. yd.',
                        'kanaal',
                        'marabba',
                        'marla'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedAreaType = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: _decoratedTextField('Monthly Rent',
                          iconData: Icons.attach_money,
                          prefixText: '$_selectedCurrency '),
                    ),
                  ),
                  SizedBox(width: 10),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCurrency,
                      items: ['PKR', 'USD'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCurrency = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              TextField(
                decoration: _decoratedTextField('Property Description',
                    iconData: Icons.description),
                maxLines: 3,
              ),
              SizedBox(height: 10),

              TextField(
                decoration: _decoratedTextField('Email', iconData: Icons.email),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10),

              TextField(
                decoration:
                    _decoratedTextField('Phone Number', iconData: Icons.phone),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),

              Container(
                height: 50,
                width: 600,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF42210B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  onPressed: () {
                    _showPostAdDialog(context);
                    _postAd();
                  },
                  child: Text('Post Ad'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageUploadPreview extends StatelessWidget {
  final List<XFile> selectedImages;
  final Function() onImageUpload;
  final Function(int) onImageRemove;

  const ImageUploadPreview({
    required this.selectedImages,
    required this.onImageUpload,
    required this.onImageRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onImageUpload, // Use the provided callback for image upload
          child: Container(
            height: 150,
            width: double.infinity,
            color: Colors.grey[200],
            child: selectedImages.isEmpty
                ? Center(child: Text('Tap to Upload/Preview'))
                : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: selectedImages.length,
              itemBuilder: (context, index) {
                final selectedImage = selectedImages[index];
                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(File(selectedImage.path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => onImageRemove(index),
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

void _showPostAdDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Post Successful",
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF42210B)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Your post has been successfully published!",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Color(0xFF42210B))),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      primary: Color(0xFF42210B),
                      side: BorderSide(color: Color(0xFF42210B), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minimumSize: Size(150, 50),
                      backgroundColor: Colors.white,
                      onSurface: Color(0xFF42210B),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MyPropertiesScreen(),
                        ),
                      );
                    },
                    child: Text("My Properties",
                        style: TextStyle(fontFamily: 'Poppins')),
                  ),
                ),
                SizedBox(
                    width: 10), // Optional: to provide spacing between buttons
                Flexible(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF42210B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minimumSize: Size(150, 50),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LandlordHomeScreen()),
                      );
                    },
                    child: Text("Home Screen",
                        style: TextStyle(fontFamily: 'Poppins')),
                  ),
                ),
              ],
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: Colors.white,
        elevation: 5.0,
      );
    },
  );
}