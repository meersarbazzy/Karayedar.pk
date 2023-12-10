import 'package:flutter/material.dart';
import 'package:karayedar_pk/screens/homescreen.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- New import
import 'package:karayedar_pk/screens/jazz_cash_pay.dart';

class ApplyForDonationScreen extends StatefulWidget {
  @override
  _ApplyForDonationScreenState createState() => _ApplyForDonationScreenState();
}

class _ApplyForDonationScreenState extends State<ApplyForDonationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CollectionReference donations =
      FirebaseFirestore.instance.collection('donations'); // <-- New line
  TextEditingController _nameController = TextEditingController();
  TextEditingController _reasonController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  void _submitForm() async {
   // payment("");
    if (_formKey.currentState!.validate()) {
      try {
        await donations.add({
          // <-- Save data to Firestore
          'name': _nameController.text,
          'reason': _reasonController.text,
          'amount': _amountController.text,
          'phone': _phoneController.text,
          'email': _emailController.text,
        });
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => ConfirmationScreen()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to save data. Please try again.")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please fill in all mandatory fields")));
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Apply for Donation', style: TextStyle(color: Color(0xFF42210B))),
        iconTheme: IconThemeData(color: Color(0xFF42210B)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              TextFormField(
                controller: _nameController,
                decoration:
                    _decoratedTextField('Full Name', iconData: Icons.person),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your full name' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _reasonController,
                decoration: _decoratedTextField('Reason for Donation',
                    iconData: Icons.info),
                validator: (value) => value!.isEmpty
                    ? 'Please provide a reason for donation'
                    : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _amountController,
                decoration: _decoratedTextField('Amount',
                    iconData: Icons.attach_money, prefixText: 'Rs. '),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the donation amount' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                decoration:
                    _decoratedTextField('Phone Number', iconData: Icons.phone),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your phone number' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: _decoratedTextField('Email', iconData: Icons.email),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your email address' : null,
              ),
              SizedBox(height: 10),
              Text(
                'Note: Please provide accurate details and a genuine reason for donation. False information may lead to a ban.',
                style: TextStyle(color: Colors.red[700], fontSize: 14),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Color(0xFF42210B), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17))),
                onPressed: _submitForm,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Apply', style: TextStyle(fontSize: 16)),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}


class ConfirmationScreen extends StatefulWidget {
  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  @override
  void initState() {
    super.initState();
    // Set a delay to navigate back to TenantHomeScreen after 4 seconds
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  TenantHomeScreen())); // Assuming you have a screen named TenantHomeScreen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150, // Reduced size for more minimalistic look
                height: 150, // Reduced size for more minimalistic look
                child: Lottie.asset('assets/animations/done.json'),
              ),
              SizedBox(height: 30),
              Text(
                'Thank you for applying!',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20, // Reduced font size
                    fontWeight: FontWeight.w600, // Slightly lesser weight
                    color: Color(0xFF42210B)),
              ),
              SizedBox(height: 20),
              Text(
                'We will contact you, and if you are eligible for a house donation, our representative will reach out to you.',
                style: TextStyle(
                  color: Color(0xFF42210B)
                      .withOpacity(0.7), // Slight opacity for minimalism
                  fontSize: 16, // Reduced font size
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
