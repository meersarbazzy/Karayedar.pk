import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BulkUploadScreen extends StatefulWidget {
  @override
  _BulkUploadScreenState createState() => _BulkUploadScreenState();
}

class _BulkUploadScreenState extends State<BulkUploadScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _areaSizeController = TextEditingController();
  final TextEditingController _monthlyRentController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedPropertyType = 'house';
  String _selectedCurrency = 'PKR';
  List<XFile> _selectedImages = [];

  void _uploadPictures() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  InputDecoration _decoratedTextField(String labelText, IconData icon) {
    return InputDecoration(
      labelText: labelText,
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      prefixIcon: Icon(icon, color: Colors.grey),
    );
  }

  void _submitProperties() async {
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload at least one image')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Center(child: CircularProgressIndicator()),
    );

    List<String> imageUrls = [];
    for (var imageFile in _selectedImages) {
      String fileName = 'realtorProperties/${Timestamp.now().seconds}_${imageFile.name}';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageRef.putFile(File(imageFile.path));
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();
      imageUrls.add(imageUrl);
    }

    Map<String, dynamic> propertyData = {
      'address': _addressController.text,
      'areaSize': _areaSizeController.text,
      'monthlyRent': _monthlyRentController.text,
      'description': _descriptionController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'propertyType': _selectedPropertyType,
      'currency': _selectedCurrency,
      'imageUrls': imageUrls,
      'userId': FirebaseAuth.instance.currentUser?.uid, // Add this line

    };

    await FirebaseFirestore.instance.collection('realtorProperties').add(propertyData);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Property submitted successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bulk Property Upload'),
        backgroundColor: Color(0xFF42210B),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedPropertyType,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPropertyType = newValue!;
                });
              },
              items: <String>['house', 'warehouse', 'farmhouse', 'apartment', 'otherProperties']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value.capitalize()),
                );
              }).toList(),
              decoration: _decoratedTextField('Property Type', Icons.house),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _addressController,
              decoration: _decoratedTextField('Address', Icons.location_on),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _areaSizeController,
              decoration: _decoratedTextField('Area Size', Icons.square_foot),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _monthlyRentController,
              decoration: _decoratedTextField('Monthly Rent', Icons.attach_money),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: _decoratedTextField('Description', Icons.description),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: _decoratedTextField('Email', Icons.email),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: _decoratedTextField('Phone Number', Icons.phone),
            ),
            SizedBox(height: 20),
            Text('Upload Images', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            ImageUploadPreview(
              selectedImages: _selectedImages,
              onImageUpload: _uploadPictures,
              onImageRemove: _removeImage,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitProperties,
              child: Text('Submit Properties'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF42210B),
              ),
            ),
          ],
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
          onTap: onImageUpload,
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
            ),
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

extension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
