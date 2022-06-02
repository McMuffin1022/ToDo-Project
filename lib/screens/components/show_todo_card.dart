import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/constant.dart';
import 'package:todoapp/database_helper.dart';
import 'package:todoapp/screens/add_to_do_screen.dart';
import 'package:todoapp/screens/components/task_info.dart';
import 'package:todoapp/screens/to_do_screen.dart';

class ShowTodoCard extends StatefulWidget {
  const ShowTodoCard({Key? key, this.selectedDate}) : super(key: key);
  final DateTime? selectedDate;

  @override
  State<ShowTodoCard> createState() => _ShowTodoCardState();
}

class _ShowTodoCardState extends State<ShowTodoCard> {
  @override
  Widget build(BuildContext context) {
    DatabaseHelper _dbHelper = DatabaseHelper();

    //Fonction permettand d<afficher ou non la date s'il y a lieu
    bool getContentDateVisible(AsyncSnapshot snapshot, int index) {
      bool _contentDateVisible = false;
      if (snapshot.data[index].TodoDate == null) {
        _contentDateVisible = false;
      } else if (snapshot.data[index].TodoDate == "") {
        _contentDateVisible = false;
      } else {
        _contentDateVisible = true;
      }
      return _contentDateVisible;
    }

//fonction permettant de formatter la date dans le format voulu
    String getDateFormat(AsyncSnapshot snapshot, int index) {
      String dateFormat = "";
      try {
        dateFormat = DateFormat.yMMMMd()
            .format(DateTime.parse(snapshot.data[index].TodoDate));
      } catch (e) {
        dateFormat = "";
      }
      return dateFormat;
    }

//fonction permettant d'afficher les types ou non s'il y a lieu
    bool getContentTypesVisible(AsyncSnapshot snapshot, int index) {
      bool _contentTypesVisible = false;
      return _contentTypesVisible;
    }

    return Expanded(
      /////////////////////////////////////////////////////////////
      /// Je vais chercher mes données afin des affichers
      ///   /////////////////////////////////////////////////////////////
      child: FutureBuilder(
          initialData: [],
          future: widget.selectedDate != null ? _dbHelper.getTodoDate(widget.selectedDate!) : _dbHelper.getTodo(),
          builder: (context, AsyncSnapshot snapshot) {
            return ScrollConfiguration(
                behavior: NoGlowBehaviour(),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      try {
                        return Padding(
                          padding: EdgeInsets.only(bottom: kDefaultPadding),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddToDoScreen(
                                    todo: snapshot.data[index],
                                  ),
                                ),
                              ).then((value) => setState(() {}));
                            },
                            onLongPress: () {
                              _dbHelper
                                  .deleteTodo(snapshot.data[index].ID_Todo);
                              setState(() {
                                if(widget.selectedDate != null)    _dbHelper.getTodoDate(widget.selectedDate!);
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(kRadius),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 10),
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.15),
                                    ),
                                  ]),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: kDefaultPadding - 5,
                                    left: kDefaultPadding - 5,
                                    right: kDefaultPadding - 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    /////////////////////////////////////////////////////////////
                                    /// Je vais chercher mes types afin de les mettre ou non
                                    ///   /////////////////////////////////////////////////////////////
                                    FutureBuilder(
                                        initialData: [],
                                        future: _dbHelper.getTypesId(
                                            snapshot.data[index].ID_Todo),
                                        builder:
                                            (context, AsyncSnapshot snapshot) {
                                          bool afficherType = false;

                                          if (snapshot.data.isEmpty) {
                                            afficherType = false;
                                          } else {
                                            afficherType = true;
                                          }
                                          try {
                                            return Visibility(
                                              visible: afficherType,
                                              child: Container(
                                                height: 30,
                                                child: ListView.builder(
                                                    itemCount:
                                                        snapshot.data.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      if (snapshot
                                                              .data.length ==
                                                          0) {}
                                                      return SingleChildScrollView(
                                                        child: Wrap(
                                                          direction:
                                                              Axis.horizontal,
                                                          clipBehavior:
                                                              Clip.hardEdge,
                                                          children: snapshot
                                                              .data
                                                              .map((item) {
                                                                try {
                                                                  return TaskInfo(
                                                                    title: item
                                                                            .TypeName
                                                                        .toString(),
                                                                    color: item
                                                                            .TypeColor
                                                                        .toString(),
                                                                  );
                                                                } catch (e) {}
                                                              })
                                                              .toList()
                                                              .cast<Widget>(),
                                                        ),
                                                      );
                                                    }),
                                              ),
                                            );
                                          } catch (e) {
                                            return Container();
                                          }
                                        }),
                                    Text(
                                      snapshot.data[index].TodoName,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Visibility(
                                      visible: snapshot.data[index]
                                                  .TodoDescription !=
                                              ""
                                          ? true
                                          : false,
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 6, bottom: 8),
                                          child: Text(snapshot
                                              .data[index].TodoDescription)),
                                    ),
                                    Visibility(
                                      visible: getContentDateVisible(
                                          snapshot, index),
                                      child: Text(
                                        (getDateFormat(snapshot, index)),
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0x99000000),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(bottom: 10))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } catch (e) {
                        return Container();
                      }
                    }));
          }),
    );
  }
}
