class Todo {
  final int? ID_Todo;
  final String? TodoName;
  final String? TodoDescription;
  final String? TodoDate;

  Todo({this.ID_Todo, this.TodoName, this.TodoDescription, this.TodoDate});

  Map<String, dynamic> toMap() {
    return {
      'ID_Todo': ID_Todo,
      'TodoName': TodoName,
      'TodoDescription': TodoDescription,
      'TodoDate': TodoDate
    };
  }
}
