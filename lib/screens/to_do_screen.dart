import 'package:flutter/material.dart';
import 'package:todoapp/constant.dart';
import 'package:todoapp/database_helper.dart';
import 'package:todoapp/screens/calendar_screen.dart';
import 'package:todoapp/screens/components/buttons/add_todo_button.dart';
import 'package:todoapp/screens/components/show_todo_card.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({Key? key}) : super(key: key);
  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  bool _dateFilter = false;
  DatabaseHelper _dbHelper = DatabaseHelper();

//Widget qui affiche la page des To-Do
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
                  /////////////////////////////////////////////////////////////
                //Header page TO-DO
                  /////////////////////////////////////////////////////////////
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: kDefaultPadding, bottom: kDefaultPadding),
                    child: Row(
                      children: [
                        Text(
                          "To-Do",
                          style: TextStyle(fontFamily: 'Salsa', fontSize: 32),
                        ),
                        Spacer(),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => StatefulBuilder(
                                              builder: (context, setState) =>
                                                  CalendarScreen())))
                                  .then((value) => (setState(() {
                                        _dbHelper.getTodoDate(DateTime.now());
                                      })));
                            },
                            child: Icon(Icons.arrow_forward, size: 40)),
                      ],
                    ),
                  ),
                  /////////////////////////////////////////////////////////////
                  //Body de la page To-Do
                    /////////////////////////////////////////////////////////////
                  ShowTodoCard(),
                ],
              ),
              AddTodoButton(size: size),
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


