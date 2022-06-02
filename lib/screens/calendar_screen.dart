import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todoapp/constant.dart';
import 'package:todoapp/database_helper.dart';
import 'package:todoapp/screens/components/buttons/add_todo_date_button.dart';
import 'package:todoapp/screens/components/show_todo_card.dart';
import 'package:todoapp/screens/components/title_text.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  DatabaseHelper _dbHelper = DatabaseHelper();
  int nbTodo = 0;

  getTodoCount() async {
    _selectedDay = DateTime.now();
    await _dbHelper.getTodoDate(_selectedDay!);

    nbTodo = await DatabaseHelper.todoDateTableLength;
    setState(() {});
  }

  /////////////////////////////////
//Fonction qui se lance lors du lancement du widget
  /////////////////////////////////

  @override
  void initState() {
    super.initState();

    getTodoCount();
    _selectedDay = DateTime.now();
    _dbHelper.getTodoDate(_selectedDay!);

    setState(() {
      _selectedDay = DateTime.now();
      _dbHelper.getTodoDate(_selectedDay!);
      getTodoCount();

      nbTodo = DatabaseHelper.todoDateTableLength;
    });
    WidgetsBinding.instance?.addPostFrameCallback((_) => getTodoCount());
    super.initState();
  }
  /////////////////////////////////
//Widget qui affiche le calendrier
  /////////////////////////////////

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    nbTodo = DatabaseHelper.todoDateTableLength;
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
              //////////////////////////////////////
              ///Header du calendrier
              //////////////////////////////////////
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 40,
                  )),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Row(
                      children: [
                        Spacer(),
                        Text(
                          "Calendrier",
                          style: TextStyle(fontSize: 32),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: kDefaultPadding, left: kDefaultPadding),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //////////////////////////////////////
                            ///Card du Calendrier
                            //////////////////////////////////////

                            GestureDetector(
                              onTap: () {
                                showCalendar(context, size).then((value) => {
                                      setState(() {
                                        _dbHelper
                                            .getTasksCount(_selectedDay!)
                                            .then((value) => (setState(() {
                                                  nbTodo = 1;
                                                })));
                                        _dbHelper.getTodoDate(_selectedDay!);
                                        nbTodo = 1;
                                      })
                                    });
                              },
                              onLongPress: () {
                                setState(() {
                                  _selectedDay = DateTime.now();
                                  _focusedDay = DateTime.now();
                                  _dbHelper.getTodoDate(_selectedDay!);
                                });
                              },
                              child: Container(
                                width: size.width / 2.8,
                                height: size.height / 4,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(kRadius))),
                                child: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Spacer(),
                                      Text(
                                        DateFormat.EEEE().format(_selectedDay!),
                                        style: TextStyle(fontSize: 22),
                                      ),
                                      Text(
                                        _selectedDay!.day.toString(),
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        width: 10,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            stops: [0.01, 0.99],
                                            colors: [
                                              Color(0x99E68FBE),
                                              Color(0x995377DB)
                                            ],
                                          ),
                                        ),
                                      ),
                                      Text(
                                        DateFormat.MMMM().format(_selectedDay!),
                                        style: TextStyle(fontSize: 22),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                )),
                              ),
                            ),
                            Spacer(),
                            //////////////////////////////////////
                            ///Card du nombre de todo pour une periode X
                            //////////////////////////////////////
                            Container(
                              width: size.width / 2.8,
                              height: size.height / 6.5,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.01, 0.99],
                                    colors: [
                                      Color(0xAAE68FBE),
                                      Color(0xAA5377DB)
                                    ],
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(kRadius))),
                              child: Center(
                                child: Column(
                                  children: [
                                    Spacer(),
                                    Icon(
                                      Icons.local_fire_department_outlined,
                                      size: 70,
                                      color: Color(0xEEFFC127),
                                    ),
                                    Text("${nbTodo} à faire!",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white)),
                                    Spacer(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        TitleText(title: "To-Do"),
                      ],
                    ),
                  ),
                  ShowTodoCard(
                    selectedDate: _selectedDay,
                  ),
                ],
              ),
              AddTodoDateButton(
                size: size,
                selectedDate: _selectedDay!,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showCalendar(BuildContext context, Size size) {
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text("Calendrier"),
          content: Container(
            width: size.width / 1.2,
            height: size.height / 2,
            child: TableCalendar(
              firstDay: DateTime.utc(2022, 01, 01),
              lastDay: DateTime.utc(2025, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              locale: 'fr_CA',
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  // Call `setState()` when updating the selected day
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  Navigator.pop(context);
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _focusedDay = focusedDay;
              },
            ),
          ),
        ),
      ),
    );
  }
}
