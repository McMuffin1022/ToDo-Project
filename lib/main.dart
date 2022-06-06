import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/constant.dart';
import 'package:todoapp/screens/to_do_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  // Intl.defaultLocale = 'fr_CA';
  initializeDateFormatting().then((_) => runApp(MyApp()));
  
  runApp(const MyApp());
}
///
///Widget qui lance mon application
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Optimization',
      theme: ThemeData(
        scaffoldBackgroundColor: kBackGroundColor,
        fontFamily: 'Salsa'
      ),
      debugShowCheckedModeBanner: false,
    home: ToDoScreen(),
    );
  }
}
