import 'package:flutter/material.dart';
import 'package:todoapp/screens/add_to_do_screen.dart';
import 'package:todoapp/database_helper.dart';

class AddButton extends StatelessWidget {
  const AddButton(
      {Key? key,
      required this.size,
      this.top,
      this.right,
      this.left,
      this.bottom})
      : super(key: key);

  final Size size;
  final double? top;
  final double? right;
  final double? left;
  final double? bottom;

  @override
  Widget build(BuildContext context) {
    DatabaseHelper _dbHelper = DatabaseHelper();

    return Positioned(
      top: size.height * top!,
      right: size.width * right!,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddToDoScreen(
                        todo: null,
                      )));
          // .then((value) => {setState(() {})});
        },
        child: Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            color: Color(0xAA00B0FF),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 35,
          ),
        ),
      ),
    );
  }
}
