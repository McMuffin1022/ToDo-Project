import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todoapp/database/Type.dart';
import 'package:todoapp/database/Task.dart';
import 'package:todoapp/database/typetodo.dart';

import 'database/Task.dart';
import 'database/Todo.dart';

class DatabaseHelper {
  static int todoTableLength = 0;
  static int todoDateTableLength = 0;
  static int taskTableLength = 0;
  static int typeTableLength = 0;
  static int typeTodoTableLength = 0;

  Future<Database> database() async {
    WidgetsFlutterBinding.ensureInitialized();
    return openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE Todo(ID_Todo INTEGER PRIMARY KEY, TodoName TEXT NULL,TodoDescription TEXT NULL,TodoDate DATETIME NULL);");
        await db.execute(
            "CREATE TABLE Tasks(ID_Task INTEGER PRIMARY KEY,TaskName TEXT NULL,TaskDone INTEGER DEFAULT 0, ID_Todo INTEGER);");
        await db.execute(
            "CREATE TABLE Types( ID_Type INTEGER PRIMARY KEY, TypeName TEXT NULL, TypeColor TEXT NULL);");
        await db.execute(
            "CREATE TABLE TypesTodo( ID_TypeTodo INTEGER PRIMARY KEY, ID_Type INTEGER, ID_Todo INTEGER);");
      },
      version: 1,
    );
  }

  //? CRUD DE TYPE
  //! CREATE
  Future<void> insertType(Type type) async {
    Database _db = await database();
    await _db.insert('Types', type.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //! READ
  Future<List<Type>> getTypes() async {
    Database _db = await database();
    List<Map<String, dynamic>> typeMap = await _db.query('Types');
    typeTableLength = typeMap.length;
    return List.generate(typeMap.length, (index) {
      return Type(
          ID_Type: typeMap[index]['ID_Type'],
          TypeName: typeMap[index]['TypeName'],
          TypeColor: typeMap[index]['TypeColor']);
    });
  }

  //! DEL
  Future<void> deleteType(int id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM Types WHERE ID_Type = $id");
  }

  /////////////////////////////////////////////////////////////////////
  //? CRUD DE TASK
  //! CREATE
  Future<void> insertTask(Task task) async {
    Database _db = await database();
    await _db.insert('Tasks', task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //! READ
  Future<List<Task>> getTasks(int id) async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap =
        await _db.rawQuery('SELECT * FROM Tasks where ID_Todo = $id');
    taskTableLength = taskMap.length;
    return List.generate(taskMap.length, (index) {
      return Task(
          ID_Task: taskMap[index]['ID_Task'],
          TaskName: taskMap[index]['TaskName'],
          TaskDone: taskMap[index]['TaskDone'],
          ID_Todo: taskMap[index]['ID_Todo']);
    });
  }

  Future<void> getTasksCount(DateTime date) async {
    Database _db = await database();
    String formatDate = date.month.toString();
    List<Map<String, dynamic>> taskMap = [];
    List<Map<String, dynamic>> taskMapCount = [];
    taskTableLength = 0;
    // List<Map<String, dynamic>> taskMap = await _db.rawQuery("SELECT ID_TODO,  STRFTIME('%m/%d/%Y', TodoDate) AS date FROM Todo where date = '${DateFormat.yMd().format(date!)}'");
    taskMap = await _db.rawQuery(
        "SELECT ID_TODO,  STRFTIME('%m/%d/%Y', TodoDate) AS date FROM Todo where date = '${DateFormat('MM/dd/yyyy').format(date)}'");

    for (var element in taskMap) {
      taskMapCount = await _db.rawQuery(
          "SELECT ID_Task FROM Tasks WHERE ID_Todo = ${element['ID_Todo']}");
      taskTableLength = taskTableLength + taskMapCount.length;
    }

  }

  //! UPDATE
  Future<void> updateTask(int id, int isDone) async {
    Database _db = await database();
    await _db
        .rawUpdate("Update Tasks SET TaskDone = $isDone WHERE ID_Task = $id");
  }

  //! DELETE
  Future<void> deleteTask(int id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM tasks where ID_Task = $id");
  }

  //? CRUD DE TYPETODO
  //! CREATE
  Future<void> insertTypeTodo(TypeTodo typetodo) async {
    Database _db = await database();
    await _db.insert('TypesTodo', typetodo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  //! READ
  Future<List<Type>> getTypesId(int id) async {
    Database _db = await database();
    List<Map<String, dynamic>> typeMap = await _db.rawQuery(
        'SELECT Types.TypeName, Types.TypeColor, Types.ID_Type FROM Types INNER JOIN TypesTodo ON TypesTodo.ID_Type = Types.ID_Type WHERE TypesTodo.ID_Todo == $id');
    typeTodoTableLength = typeMap.length;

    if(typeMap.isEmpty){

      return List.generate(typeMap.length, (index) {
      return Type(
          ID_Type: typeMap[index]['0'],
          TypeName: typeMap[index][''],
          TypeColor: typeMap[index]['']
          );
    });
    }else{
      
    return List.generate(typeMap.length, (index) {
      return Type(
          ID_Type: typeMap[index]['ID_Type'],
          TypeName: typeMap[index]['TypeName'],
          TypeColor: typeMap[index]['TypeColor']
          );
    });
    }
  }

  //! READ
  Future<int> getTypesIdLength(int id) async {
    Database _db = await database();
    List<Map<String, dynamic>> typeMap = await _db.rawQuery(
        'SELECT Types.TypeName, Types.TypeColor FROM Types INNER JOIN TypesTodo ON TypesTodo.ID_Type = Types.ID_Type WHERE TypesTodo.ID_Todo == $id');
    typeTodoTableLength = await typeMap.length;
    return typeTodoTableLength;
  }

  //! DELETE
  Future<void> deleteTypeTodo(int id_type, int id_todo) async {
    Database _db = await database();
    await _db.rawDelete(
        "DELETE FROM TypesTodo WHERE ID_Type = $id_type AND ID_Todo = $id_todo");
  }

  //? CRUD DE TODO
  //! CREATE
  Future<int> insertTodo(Todo todo) async {
    int todoId = 0;
    Database _db = await database();
    await _db
        .insert('Todo', todo.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      todoId = value;
    });
    return todoId;
  }

  //! UPDATE
  Future<void> updateTodoTitle(int id, String title) async {
    Database _db = await database();
    await _db
        .rawUpdate('UPDATE Todo set TodoName = "$title" WHERE ID_Todo = $id');
  }

  Future<void> updateTodoDescription(int id, String todoDescription) async {
    Database _db = await database();
    await _db.rawUpdate(
        'UPDATE Todo set TodoDescription = "$todoDescription" WHERE ID_Todo = $id');
  }

  Future<void> updateTodoDate(int id, DateTime date) async {
    Database _db = await database();
    await _db
        .rawUpdate('UPDATE Todo set TodoDate = "$date" WHERE ID_Todo = $id');
  }

  //! READ
  Future<List<Todo>> getTodo() async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap = await _db.query('Todo');
    todoTableLength = todoMap.length;
    return List.generate(todoMap.length, (index) {
      return Todo(
          ID_Todo: todoMap[index]['ID_Todo'],
          TodoName: todoMap[index]['TodoName'],
          TodoDescription: todoMap[index]['TodoDescription'],
          TodoDate: (todoMap[index]['TodoDate']));
    });
  }

    //! READ
  Future<List<Todo>> getTodoDate(DateTime date) async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap = await _db.rawQuery("SELECT ID_Todo,TodoName,TodoDescription,  TodoDate,STRFTIME('%m/%d/%Y', TodoDate) AS TodoDateTarget FROM Todo WHERE TodoDateTarget = '${DateFormat('MM/dd/yyyy').format(date)}'");
    todoDateTableLength = todoMap.length;


    print(todoMap);
     return List.generate(todoMap.length, (index) {
      return Todo(
          ID_Todo: todoMap[index]['ID_Todo'],
          TodoName: todoMap[index]['TodoName'],
          TodoDescription: todoMap[index]['TodoDescription'],
          TodoDate: (todoMap[index]['TodoDate']));
    });
  }

  

  //! DELETE
  Future<void> deleteTodo(int id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM todo WHERE ID_Todo = $id");
    await _db.rawDelete("DELETE FROM tasks WHERE ID_Todo = $id");
    await _db.rawDelete("DELETE FROM typestodo WHERE ID_Todo = $id");
  }

  Future<void> deleteTodoDate(int id) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE Todo set TodoDate = '' WHERE ID_Todo = $id");
  }
}
