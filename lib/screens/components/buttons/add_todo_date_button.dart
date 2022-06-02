import 'package:flutter/material.dart';
import 'package:todoapp/database_helper.dart';
import 'package:todoapp/screens/add_to_do_screen.dart';

class AddTodoDateButton extends StatefulWidget {
  const AddTodoDateButton(
      {Key? key, required this.size, required this.selectedDate})
      : super(key: key);

  final Size size;
  final DateTime selectedDate;

  @override
  State<AddTodoDateButton> createState() => _AddTodoDateButtonState();
}

class _AddTodoDateButtonState extends State<AddTodoDateButton> {
  @override
  Widget build(BuildContext context) {
    DatabaseHelper _dbHelper = DatabaseHelper();
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
                selectedDate: widget.selectedDate,
                onDeleteTodo: () {
                  _dbHelper.getTodoDate(widget.selectedDate);
                  setState(() {
                    _dbHelper.getTodoDate(widget.selectedDate);
                  });
                },
              ),
            ),
          ).then((value) => setState(() {}));
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
