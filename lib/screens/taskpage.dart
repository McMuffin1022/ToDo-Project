import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/database_helper.dart';
import 'package:to_do/models/task.dart';
import 'package:to_do/models/todo.dart';
import 'package:to_do/widgets.dart';

class Taskpage extends StatefulWidget {
  final Task? task;
  Taskpage({required this.task});

  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  int? _taskId = 0;
  String? _taskTitle = "";
  String? _taskDescription = "";
  String? _todoText = "";

  FocusNode? _titleFocus;
  FocusNode? _descriptionFocus;
  FocusNode? _todoFocus;

  bool _contentVisible = false;

  @override
  void initState() {
    if (widget.task != null) {
      //Set visibility to true
      _contentVisible = true;

      _taskTitle = widget.task!.title;
      if (widget.task!.description == null) {
        _taskDescription = "Unamed description";
        print("info description");
      } else {
        // _taskDescription == "test";
        _taskDescription = widget.task!.description;
        print("info description");
      }

      print("Avant : $_taskId");
      _taskId = widget.task!.id;
      print("Apres $_taskId");
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _titleFocus!.dispose();
    _descriptionFocus!.dispose();
    _todoFocus!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 24.0,
                      bottom: 12.0,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Image(
                              image: AssetImage(
                                  'assets/images/back_arrow_icon.png'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: _titleFocus,
                            onSubmitted: (value) async {
                              print("Field Value :    $value");

                              //check if the field is not empty
                              if (value != "") {
                                //check if the task is null

                                if (widget.task == null) {
                                  Task _newTask = Task(title: value);
                                  _taskId =
                                      await _dbHelper.insertTask(_newTask);
                                  print("New Task Id : $_taskId");
                                  print("New task has been created");

                                  setState(() {
                                    _contentVisible = true;
                                    _taskTitle = value;
                                  });
                                } else {
                                  print("Update the existing task");
                                  await _dbHelper.updateTaskTitle(
                                      _taskId!, value);
                                  print("task updated");
                                }

                                _descriptionFocus!.requestFocus();
                              }
                            },
                            controller: TextEditingController()
                              ..text = _taskTitle!,
                            decoration: InputDecoration(
                              hintText: "Enter text field",
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 36.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF211551),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12.0,
                      ),
                      child: TextField(
                        focusNode: _descriptionFocus,
                        onSubmitted: (value) async {
                          if (value != "") {
                            if (_taskId != 0) {
                              await _dbHelper.updateTaskDescription(
                                  _taskId!, value);
                              _taskDescription = value;
                            }
                          }
                          _todoFocus!.requestFocus();
                        },
                        controller: TextEditingController()
                          ..text = _taskDescription!,
                        decoration: InputDecoration(
                          hintText: "Enter description for the task",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTodos(_taskId!),
                      builder: (context, AsyncSnapshot snapshot) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: DatabaseHelper.todoTableLength,
                            itemBuilder: (context, index) {
                              print("INDEX : $index");
                              return GestureDetector(
                                onTap: () async {
                                  if (snapshot.data[index].isDone == 0) {
                                    await _dbHelper.updateTodoDone(
                                        snapshot.data[index].id, 1);
                                  } else {
                                    await _dbHelper.updateTodoDone(
                                        snapshot.data[index].id, 0);
                                  }

                                  setState(() {});
                                },
                                child: TodoWidget(
                                  text: snapshot.data[index].title,
                                  isDone: snapshot.data[index].isDone == 0
                                      ? false
                                      : true,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20.0,
                            height: 20.0,
                            margin: EdgeInsets.only(
                              right: 12.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(6.0),
                              border: Border.all(
                                color: Color(0xFF868290),
                                width: 1.5,
                              ),
                            ),
                            child: Image(
                              image: AssetImage('assets/images/check_icon.png'),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              focusNode: _todoFocus,
                              controller: TextEditingController()..text = "",
                              onSubmitted: (value) async {
                                //check if the field is not empty
                                if (value != "") {
                                  print("Valeur : $value");
                                  //check if the task is null
                                  // print("Widget : ${widget.task!.title}");
                                  print("Task id : $_taskId");

                                  print("Widget : $widget");
                                  if (_taskId != null) {
                                    if (_taskId != 0) {
                                      DatabaseHelper _dbHelper =
                                          DatabaseHelper();

                                      Todo _newTodo = Todo(
                                          title: value,
                                          isDone: 0,
                                          taskId: _taskId);

                                      await _dbHelper.insertTodo(_newTodo);

                                      setState(() {});
                                      _todoFocus!.requestFocus();
                                    } else {
                                      print("sa amrche pas");
                                    }

                                    print("sa marche wtffff");
                                  } else {
                                    print("sa amrche pas");
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Enter Todo item...",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: _contentVisible,
                child: Positioned(
                  bottom: 24.0,
                  right: 24.0,
                  child: GestureDetector(
                    onTap: () async {
                      if (_taskId != 0) {
                        await _dbHelper.deleteTask(_taskId!);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Image(
                          image: AssetImage(
                        "assets/images/delete_icon.png",
                      )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
