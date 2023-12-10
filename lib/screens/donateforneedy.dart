import 'package:flutter/material.dart';

class DonateForNeedy extends StatefulWidget {
  @override
  _DonateForNeedyState createState() => _DonateForNeedyState();
}

class _DonateForNeedyState extends State<DonateForNeedy> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _amountController = TextEditingController();
  bool isLoading = false;

  InputDecoration _decoratedTextField(String labelText, {IconData? iconData}) {
    return InputDecoration(
      labelText: labelText,
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      prefixIcon: iconData != null ? Icon(iconData, color: Colors.grey) : null,
    );
  }

  Future<void> initiateJazzCashPayment() async {
    setState(() {
      isLoading = true;
    });
    String pp_MerchantID = "MC59733";
    String pp_Password = "f527214a21";
    String IntegeritySalt = "02wy103988";

    // ... Your JazzCash logic goes here ...

    // Remember to set `isLoading` to false after the transaction
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Donate for the Needy',
          style: TextStyle(color: Color(0xFF42210B)),
        ),
        iconTheme: IconThemeData(color: Color(0xFF42210B)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _amountController,
                decoration: _decoratedTextField('Donation Amount',
                    iconData: Icons.attach_money),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the donation amount' : null,
              ),
              SizedBox(height: 20),
              Text(
                'Transfer your donation to the following account:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Text('Account Name: Karayedar.pk'),
              Text('Account Number: 1234567890'),
              Text('Bank Name: XYZ Bank'),
              Text('Branch Code: 00123'),
              Spacer(),
              Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF42210B),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      initiateJazzCashPayment();
                    }
                  },
                  child: Text('Confirm Donation with JazzCash'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
