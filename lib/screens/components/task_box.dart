import 'package:flutter/material.dart';

class TaskBox extends StatelessWidget {
  const TaskBox({Key? key, required this.color, this.icon}) : super(key: key);

  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black)),
      child: Icon(
        icon,
        color: Colors.white,
        size: 22,
      ),
    );
  }
}
