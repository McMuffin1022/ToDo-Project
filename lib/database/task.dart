class Task {
  final int? ID_Task;
  final String? TaskName;
  final int? TaskDone;
  final int? ID_Todo;

  Task({this.ID_Task, this.TaskName, this.TaskDone, this.ID_Todo});

  Map<String, dynamic> toMap() {
    return {
      'ID_Task': ID_Task,
      'TaskName': TaskName,
      'TaskDone': TaskDone,
      'ID_Todo': ID_Todo
    };
  }
}
