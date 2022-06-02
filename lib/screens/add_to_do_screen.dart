import 'package:flutter/material.dart';
import 'package:todoapp/constant.dart';
import 'package:todoapp/database/Todo.dart';
import 'package:todoapp/database/Task.dart';
import 'package:todoapp/database/typetodo.dart';
import 'package:todoapp/database_helper.dart';
import 'package:todoapp/screens/components/add_task_info.dart';
import 'package:todoapp/screens/components/big_task_info.dart';
import 'package:todoapp/screens/components/normal_text.dart';
import 'package:todoapp/screens/components/task_info.dart';
import 'package:todoapp/screens/components/task_todo.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/database/Type.dart';
import 'components/task_box.dart';

import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AddToDoScreen extends StatefulWidget {
  final Todo? todo;
  final DateTime? selectedDate;
  final VoidCallback? onDeleteTodo;

  AddToDoScreen({required this.todo, this.selectedDate, this.onDeleteTodo});

  @override
  State<AddToDoScreen> createState() => _AddToDoScreenState();
}

class _AddToDoScreenState extends State<AddToDoScreen> {
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  DateTime dateTime = DateTime.now();
  DatabaseHelper _dbHelper = DatabaseHelper();

  int? _idTodo = 0;
  String? _todoName = "";
  String? _todoDescription = "";
  String _todoDate = "";
  String typeName = "";

  FocusNode? _titleFocus;
  FocusNode? _descriptionFocus;
  FocusNode? _taskFocus;

  bool _contentVisible = false;

  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
    });
  }

  void showSheet(
    BuildContext context, {
    required Widget child,
    required VoidCallback onClicked,
  }) =>
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            child,
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('Done'),
            onPressed: onClicked,
          ),
        ),
      );

  ////////////////////////////////
  ///fonction qui se lance lors du widget
  ////////////////////////////////

  @override
  void initState() {
    ///Permet de vérifier si c'est un widget existant ou non quand je vais chercher ma card
    if (widget.todo != null) {
      _contentVisible = true;
      if (widget.todo!.TodoName != null) {
        _todoName = widget.todo!.TodoName;
      } else {
        _titleFocus!.requestFocus();
      }
      if (widget.todo!.TodoDescription == null) {
        _todoDescription = "";
      } else {
        _todoDescription = widget.todo!.TodoDescription;
      }

      _idTodo = widget.todo!.ID_Todo;
      try {
        _todoDate = DateTime.parse(widget.todo!.TodoDate.toString()).toString();
      } catch (e) {
        _todoDate = "No Date";
      }
    } else {
      _todoDate = "No Date";
    }

    ///
    ///Permet de faire les focus quand un champ a été complété
    ///
    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _taskFocus = FocusNode();

    if (widget.todo?.TodoName == null) _titleFocus!.requestFocus();
    if (widget.selectedDate != null) {
      _todoDate = widget.selectedDate.toString();

      setState(() {
        _todoDate = widget.selectedDate.toString();
      });
    }
    super.initState();
  }

  ///
  ///Initialise les focus
  ///
  @override
  void dispose() {
    _titleFocus!.dispose();
    _descriptionFocus!.dispose();
    _taskFocus!.dispose();

    super.dispose();
  }
///
///widget pour la page de rajouter une todo
///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
              left: kDefaultPadding,
              right: kDefaultPadding,
              top: size.height / 24),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                      ///
                      ///Endroit ou on affiche les types
                      ///
                  Wrap(
                    children: [
                      Visibility(
                        visible: _contentVisible,
                        child: GestureDetector(
                          onTap: () {
                            addNewType(context)
                                .then((value) => {setState(() {})});
                          },
                          child: AddTaskInfo(title: "+", color: "222222"),
                        ),
                      ),
                      Container(
                        height: 30,
                        width: 300,
                        child: FutureBuilder(
                            initialData: [],
                            future: _dbHelper.getTypesId(_idTodo!),
                            builder: (context, AsyncSnapshot snapshot) {
                              return SingleChildScrollView(
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  clipBehavior: Clip.hardEdge,
                                  children: snapshot.data
                                      .map((item) {
                                        return GestureDetector(
                                          onLongPress: () {
                                            _dbHelper.deleteTypeTodo(
                                                item.ID_Type, _idTodo!);
                                            setState(() {});
                                          },
                                          child: TaskInfo(
                                            title: item.TypeName.toString(),
                                            color: item.TypeColor.toString(),
                                          ),
                                        );
                                      })
                                      .toList()
                                      .cast<Widget>(),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                  ///
                  ///Endroit ou est affiché la flèche et le titre
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            if (widget.selectedDate != null)
                              _dbHelper.updateTodoDate(
                                  _idTodo!, widget.selectedDate!);

                            Navigator.pop(context);
                            if (widget.selectedDate != null)
                              _dbHelper.getTodoDate(widget.selectedDate!);
                            setState(() {});
                          },
                          child: Icon(
                            Icons.arrow_back,
                            size: 40,
                          ),
                        ),
                      ),
                      Flexible(
                        child: TextField(
                          focusNode: _titleFocus,
                          decoration: InputDecoration(
                            hintText: "Nom de la tâche",
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 32,
                          ),
                          controller: TextEditingController()
                            ..text = _todoName!,
                          onSubmitted: (value) async {
                            if (value != "") {
                              if (widget.todo == null) {
                                Todo _todo = Todo(TodoName: value);
                                _idTodo = await _dbHelper.insertTodo(_todo);
                                await _dbHelper.updateTodoDescription(
                                    _idTodo!, "");

                                setState(() {
                                  _todoName = value;
                                  _todoDescription = "";
                                  _contentVisible = true;
                                });
                              } else {
                                await _dbHelper.updateTodoTitle(
                                    _idTodo!, value);
                                setState(() {
                                  // _contentVisible = true;
                                  _todoName = value;
                                });
                              }

                              _descriptionFocus!.requestFocus();
                            } else if (_todoName != "") {
                              await _dbHelper.updateTodoTitle(_idTodo!, value);
                              setState(() {
                                // _contentVisible = true;
                                _todoName = value;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  ///
                  ///Description
                  ///
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Flexible(
                            child: TextField(
                              focusNode: _descriptionFocus,
                              decoration: InputDecoration(
                                hintText: "Description",
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              controller: TextEditingController()
                                ..text = _todoDescription!,
                              onSubmitted: (value) async {
                                if (value != "") {
                                  if (_idTodo != 0) {
                                    await _dbHelper.updateTodoDescription(
                                        _idTodo!, value);
                                    setState(() {
                                      _todoDescription = value;
                                    });
                                  }
                                  _taskFocus!.requestFocus();
                                } else {
                                  await _dbHelper.updateTodoDescription(
                                      _idTodo!, value);
                                  _todoDescription = value;
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ///
                  ///Endoit ou que l'on affiche s'il y a des tâches
                  ///
                  Visibility(
                    visible: _contentVisible,
                    child: Flexible(
                      fit: FlexFit.loose,
                      child: Container(
                        height: 700,
                        width: 500,
                        child: FutureBuilder(
                          initialData: [],
                          future: _dbHelper.getTasks(_idTodo!),
                          builder: (context, AsyncSnapshot snapshot) {
                            return ListView.builder(
                                itemCount: DatabaseHelper.taskTableLength,
                                itemBuilder: (context, index) {
                                  try {
                                    return GestureDetector(
                                        onTap: () async {
                                          if (snapshot.data[index].TaskDone ==
                                              0) {
                                            await _dbHelper.updateTask(
                                                snapshot.data[index].ID_Task,
                                                1);
                                          } else {
                                            await _dbHelper.updateTask(
                                                snapshot.data[index].ID_Task,
                                                0);
                                          }
                                          setState(() {});
                                        },
                                        child: TaskTodo(
                                          text: snapshot.data[index].TaskName,
                                          isDone:
                                              snapshot.data[index].TaskDone == 0
                                                  ? false
                                                  : true,
                                          id_Task: snapshot.data[index].ID_Task,
                                          context: context,
                                          onDeleteTask: () {
                                            setState(() {});
                                          },
                                        ));
                                  } catch (e) {}
                                  return Text("Error ");
                                });
                          },
                        ),
                      ),
                    ),
                  ),
                  ///
                  ///Endroit ou que l'on rentre les tâches
                  ///
                  Visibility(
                    visible: _contentVisible,
                    child: Expanded(
                      child: Align(
                        alignment: FractionalOffset.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: TaskBox(
                                  color: Colors.white,
                                ),
                              ),
                              Flexible(
                                child: TextField(
                                  focusNode: _taskFocus,
                                  controller: TextEditingController()
                                    ..text = "",
                                  decoration: InputDecoration(
                                    hintText: "Entrez une tâche...",
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                  onSubmitted: (value) {
                                    if (value != "") {
                                      if (_idTodo != 0) {
                                        _dbHelper.insertTask(Task(
                                            TaskName: value,
                                            TaskDone: 0,
                                            ID_Todo: _idTodo));
                                      }

                                      setState(() {
                                        // _contentVisible = true;
                                        // _todoName = value;
                                        _taskFocus!.requestFocus();
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ///Endroit ou que l'on affiche la date et le bouton supprimer
              Visibility(
                visible: _contentVisible,
                child: Positioned(
                  bottom: 15,
                  right: 1,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: GestureDetector(
                            onTap: () {
                              showSheet(
                                context,
                                child: StatefulBuilder(
                                  builder: (context, setState) => SizedBox(
                                    height: 180,
                                    child: CupertinoDatePicker(
                                      minimumYear: 2022,
                                      maximumYear: DateTime.now().year + 3,
                                      initialDateTime: DateTime.now(),
                                      mode: CupertinoDatePickerMode.date,
                                      onDateTimeChanged: (dateTime) =>
                                          setState(() {
                                        this.dateTime = dateTime;
                                      }),
                                    ),
                                  ),
                                ),
                                onClicked: () async {
                                  if (_idTodo != 0) {
                                    // _dbHelper.updateTodoDate(_idTodo!, dateTime);
                                    await _dbHelper.updateTodoDate(
                                        _idTodo!, dateTime);
                                    setState(() {
                                      _todoDate = dateTime.toString();
                                    });
                                  }
                                  Navigator.pop(context);
                                },
                              );
                            },
                            onLongPress: () async {
                              _todoDate = "No Date";
                              await _dbHelper.deleteTodoDate(_idTodo!);
                              setState(() {});
                            },
                            child: NormalText(
                                text: (_todoDate == "No Date"
                                        ? "No Date"
                                        : DateFormat.yMMMd()
                                            .format(DateTime.parse(_todoDate)))
                                    .toString())),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await _dbHelper.deleteTodo(_idTodo!);
                          if (widget.selectedDate != null) {
                            await _dbHelper.getTodoDate(widget.selectedDate!);
                          }
                          widget.onDeleteTodo;
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: BigTaskInfo(
                          color: Color(int.parse("0xff2B4970")),
                          icon: Icons.restore_from_trash,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> addNewType(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Type"),
                    Spacer(),
                    GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (
                                context,
                              ) =>
                                  AlertDialog(
                                    title: Text("Nouveau Type"),
                                    content: StatefulBuilder(
                                      builder: (BuildContext context,
                                              StateSetter setState) =>
                                          Container(
                                        height: 50,
                                        width: 50,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text("Couleur "),
                                                GestureDetector(
                                                  child: Container(
                                                    width: 100,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                        color: currentColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    kRadius)),
                                                  ),
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        title: const Text(
                                                            'Choisisez une couleur!'),
                                                        content:
                                                            SingleChildScrollView(
                                                          child: ColorPicker(
                                                            pickerColor:
                                                                pickerColor,
                                                            onColorChanged:
                                                                changeColor,
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          GestureDetector(
                                                            child:
                                                                Text('Valider'),
                                                            onTap: () {
                                                              setState(() {
                                                                currentColor =
                                                                    pickerColor;
                                                              });
                                                              currentColor =
                                                                  pickerColor;

                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 8.0),
                                              child: Row(
                                                children: [
                                                  Text("Type "),
                                                  SizedBox(
                                                    width: 150,
                                                    height: 20,
                                                    child: TextField(
                                                      decoration:
                                                          InputDecoration
                                                              .collapsed(
                                                        hintText: "Type...",
                                                      ),
                                                      onSubmitted: (value) {
                                                        typeName = value;
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Annulez")),
                                      TextButton(
                                          onPressed: () {
                                            _dbHelper.insertType(Type(
                                                TypeName: typeName,
                                                TypeColor:
                                                    currentColor.toString()));
                                            setState(() {});
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Confirmez")),
                                    ],
                                  ));
                        },
                        child: AddTaskInfo(title: "+", color: "222222")),
                  ],
                ),
                content: Wrap(
                  children: [
                    Container(
                      height: 300,
                      child: FutureBuilder(
                          initialData: [],
                          future: _dbHelper.getTypes(),
                          builder: (context, AsyncSnapshot snapshot) {
                            return SingleChildScrollView(
                              child: Wrap(
                                direction: Axis.horizontal,
                                clipBehavior: Clip.hardEdge,
                                children: snapshot.data
                                    .map((item) {
                                      return GestureDetector(
                                        onTap: () {
                                          _dbHelper.insertTypeTodo(TypeTodo(
                                              ID_Type: item.ID_Type,
                                              ID_Todo: _idTodo));
                                          Navigator.pop(context);
                                        },
                                        onLongPress: () {
                                          _dbHelper.deleteType(item.ID_Type);
                                          Navigator.pop(context);
                                        },
                                        child: TaskInfo(
                                          title: item.TypeName.toString(),
                                          color: item.TypeColor.toString(),
                                        ),
                                      );
                                    })
                                    .toList()
                                    .cast<Widget>(),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ));
  }
}
