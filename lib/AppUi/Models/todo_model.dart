import 'package:uuid/uuid.dart';

class Todo {
  final String id;
  String title;
  bool isCompleted;
  final DateTime createdDate;

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.createdDate,
  });

  factory Todo.create({
    required String title,
  }) {
    return Todo(
      id: const Uuid().v4(),
      title: title,
      createdDate: DateTime.now(),
    );
  }
}