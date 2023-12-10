import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String selectedType = "";
  String selectedMeasurementUnit = "";
  double minPrice = 0;
  double maxPrice = 1000000; // Some maximum value

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filters'),
      content: Column(
        children: [
          DropdownButton<String>(
            value: selectedType,
            items: ['house', 'apartment', 'warehouse', 'farmhouse'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedType = newValue!;
              });
            },
          ),
          // Add more dropdowns or sliders for other filters...
        ],
      ),
      actions: [
       TextButton(
    child: Text('Apply'),
    onPressed: () {
        // Return filtered properties and update the UI
        Navigator.of(context).pop();
    },
),
      ],
    );
  }
}
