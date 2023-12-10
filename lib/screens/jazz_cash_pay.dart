import 'package:flutter/material.dart';

class JazzCashPage extends StatefulWidget {
  @override
  _JazzCashPageState createState() => _JazzCashPageState();
}

class _JazzCashPageState extends State<JazzCashPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Details'),
        backgroundColor: Colors.green[800], // Green AppBar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Karayedar.pk',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.green[800], // Text color
              ),
            ),
            SizedBox(height: 20), // Add space between text and mockup details
            Text(
              'Account Number: 1234-5678-9012',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Bank: Meezan Bank',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Branch: Islamabad',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 40), // Add space before the button
          ],
        ),
      ),
    );
  }
}
