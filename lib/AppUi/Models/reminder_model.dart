class Reminder {
  final String id;
  final String title;
  final String description;
  final DateTime reminderDateTime;
  final bool isCompleted;

  Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.reminderDateTime,
    this.isCompleted = false,
  });

  // Method to create a copy of the Reminder with updated values
  Reminder copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? reminderDateTime,
    bool? isCompleted,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      reminderDateTime: reminderDateTime ?? this.reminderDateTime,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}