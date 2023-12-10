import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  String _profileImageUrl = "";

  bool _isNameEditable = false;
  bool _isPhoneNumberEditable = false;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _nameController.text = _user?.displayName ?? "";
    _phoneNumberController.text = _user?.phoneNumber ?? "";
    _profileImageUrl = _user?.photoURL ?? "";
  }

  void _toggleNameEdit() {
    setState(() {
      _isNameEditable = !_isNameEditable;
    });
  }

  void _togglePhoneNumberEdit() {
    setState(() {
      _isPhoneNumberEditable = !_isPhoneNumberEditable;
    });
  }

  void _saveName() {
    String updatedName = _nameController.text;
    _user?.updateDisplayName(updatedName);
    setState(() {
      _isNameEditable = false;
    });
  }

  void _savePhoneNumber() {
    String updatedPhoneNumber = _phoneNumberController.text;
    // Update phone number in Firebase if needed

    setState(() {
      _isPhoneNumberEditable = false;
    });
  }

  void _showOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose an option"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Camera"),
                onTap: () {
                  Navigator.of(context).pop();
                  _updateProfilePicture(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text("Gallery"),
                onTap: () {
                  Navigator.of(context).pop();
                  _updateProfilePicture(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text("Delete"),
                onTap: () {
                  Navigator.of(context).pop();
                  _deleteProfilePicture();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateProfilePicture(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final Reference storageReference = FirebaseStorage.instance.ref()
          .child('profile_pictures')
          .child('${_user?.uid}.jpg');

      final UploadTask uploadTask = storageReference.putFile(File(pickedFile.path));

      uploadTask.whenComplete(() async {
        final String imageUrl = await storageReference.getDownloadURL();

        setState(() {
          _profileImageUrl = imageUrl;
        });
      });
    }
  }

  void _deleteProfilePicture() async {
    final storageReference = FirebaseStorage.instance.ref()
        .child('profile_pictures')
        .child('${_user?.uid}.jpg');

    await storageReference.delete();

    setState(() {
      _profileImageUrl = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Color(0xFF42210B), // Set the brown color
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage(_profileImageUrl),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.photo_camera),
                        onPressed: _showOptionsDialog,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _nameController,
                    readOnly: !_isNameEditable,
                    decoration: InputDecoration(
                      labelText: "Name",
                      suffixIcon: IconButton(
                        icon: Icon(_isNameEditable ? Icons.save : Icons.edit),
                        onPressed: _isNameEditable ? _saveName : _toggleNameEdit,
                      ),
                    ),
                    autofocus: _isNameEditable,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.phone),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _phoneNumberController,
                    readOnly: !_isPhoneNumberEditable,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      suffixIcon: IconButton(
                        icon: Icon(_isPhoneNumberEditable ? Icons.save : Icons.edit),
                        onPressed: _isPhoneNumberEditable
                            ? _savePhoneNumber
                            : _togglePhoneNumberEdit,
                      ),
                    ),
                    autofocus: _isPhoneNumberEditable,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
