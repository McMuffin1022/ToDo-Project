import 'package:flutter/material.dart';

class NormalText extends StatelessWidget {
  const NormalText({Key? key, required this.text, this.isDone})
      : super(key: key);

  final String text;
  final bool? isDone;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 20),
    );
  }
}
