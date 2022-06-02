import 'package:flutter/material.dart';
import 'package:todoapp/screens/add_to_do_screen.dart';

class AddTodoButton extends StatefulWidget {
  const AddTodoButton({Key? key, required this.size}) : super(key: key);
  final Size size;

  @override
  State<AddTodoButton> createState() => _AddTodoButtonState();
}

class _AddTodoButtonState extends State<AddTodoButton> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.size.height * 0.79,
      right: widget.size.width * 0.01,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddToDoScreen(
                      todo: null,
                    )),
          ).then((value) => {setState(() {})});
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
