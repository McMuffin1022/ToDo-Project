import 'package:flutter/material.dart';

class BigTaskInfo extends StatelessWidget {
  const BigTaskInfo({Key? key, required this.color, this.icon})
      : super(key: key);

  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black)),
      child: Icon(
        icon,
        color: Colors.white,
        size: 50,
      ),
    );
  }
}
