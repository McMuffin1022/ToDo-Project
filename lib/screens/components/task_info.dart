import 'package:flutter/material.dart';
import 'package:todoapp/constant.dart';
class TaskInfo extends StatelessWidget {
  const TaskInfo({
    Key? key, required this.title, required this.color,
  }) : super(key: key);

  final String? title;
  final String? color;
  @override
  Widget build(BuildContext context) {
    String colorModifyString;

    colorModifyString = color!;
    colorModifyString = colorModifyString.replaceAll("Color(0x","" );
    colorModifyString = colorModifyString.replaceAll(")","" );
    colorModifyString = colorModifyString.substring(2);
    // print("COLOR FORMAT : $colorModifyString");
    return Padding(
      padding: EdgeInsets.only( right: 10, bottom: 10),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
                left: 8, right: 8, top: 5, bottom: 5),
            decoration: BoxDecoration(
              color: Color(int.parse("0x99${colorModifyString}")),
              borderRadius: BorderRadius.all(
                Radius.circular(kRadius),
              ),
            ),
            child: Text(
              title!,
              style: TextStyle(
                  color: Color(int.parse("0xff${colorModifyString}")), fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
