import 'package:flutter/material.dart';
import 'package:todoapp/database_helper.dart';
import 'package:todoapp/screens/components/task_box.dart';

class TaskTodo extends StatelessWidget {
  final String text;
  final bool isDone;
  final int id_Task;
  final BuildContext context;
  final VoidCallback onDeleteTask;

  const TaskTodo(
      {Key? key,
      required this.text,
      required this.isDone,
      required this.id_Task,
      required this.context,
      required this.onDeleteTask})
      : super(key: key);

  @override
  Widget build(context) {
    DatabaseHelper _dbHelper = DatabaseHelper();
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 25,
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: TaskBox(
              color:
                  this.isDone ? Color(int.parse("0xff2B4970")) : Colors.white,
            ),
          ),
          Flexible(
              fit: FlexFit.tight,
              child: Text(
                this.text,
                style: TextStyle(
                  fontWeight: this.isDone ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 18,
                ),
              )),
          GestureDetector(
            onTap: () {
              onDeleteTask:
              () => print("DELETE LA TASK");
              _dbHelper.deleteTask(this.id_Task);
              onDeleteTask();
            },
            child: Padding(
              padding: EdgeInsets.only(right: 5),
              child: this.isDone
                  ? TaskBox(
                      color: Color(int.parse("0xff2B4970")),
                      icon: Icons.restore_from_trash)
                  : Text(""),
            ),
          ),
        ],
      ),
    );
  }
}
