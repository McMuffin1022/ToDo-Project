class TypeTodo {
  final int? ID_TypeTodo;
  final int? ID_Type;
  final int? ID_Todo;

  TypeTodo(
      { this.ID_TypeTodo,
      required this.ID_Type,
      required this.ID_Todo});

  Map<String, dynamic> toMap() {
    return {'ID_TypeTodo': ID_TypeTodo, 'ID_Type': ID_Type, 'ID_Todo': ID_Todo};
  }
}
