import 'package:flutter/material.dart';


class TextMessageUrlWidget extends StatelessWidget {
  final String textMessage;

  const TextMessageUrlWidget({Key? key, required this.textMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      textMessage,
      style: TextStyle(fontSize: 18),
    );
  }
}
