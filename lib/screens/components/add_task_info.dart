import 'package:flutter/material.dart';
import 'package:todoapp/constant.dart';

class AddTaskInfo extends StatelessWidget {
  const AddTaskInfo({
    Key? key,
    required this.title,
    required this.color,
  }) : super(key: key);

  final String title;
  final String color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10, bottom: 10),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
            decoration: BoxDecoration(
              color: Color(int.parse("0x55222222")),
              borderRadius: BorderRadius.all(
                Radius.circular(kRadius),
              ),
            ),
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
