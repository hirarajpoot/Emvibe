import 'package:uuid/uuid.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdDate;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdDate,
  });

  factory Note.create({
    required String title,
    required String content,
  }) {
    return Note(
      id: const Uuid().v4(),
      title: title,
      content: content,
      createdDate: DateTime.now(),
    );
  }
}