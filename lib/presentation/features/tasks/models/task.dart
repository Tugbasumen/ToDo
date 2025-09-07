import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime date;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    required this.date,
  });

  factory Task.fromMap(Map<String, dynamic> map, String documentId) {
    return Task(
      id: documentId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      date: map['date'] != null
          ? (map['date'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "description": description,
      "isCompleted": isCompleted,
      "date": date,
    };
  }
}
