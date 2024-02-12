import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:up_todo/layers/models/category.dart';

class Task {
  final String? id;
  final String title;
  final String description;
  final Category category;
  final int priority;
  final DateTime date;
  final String time;
  final bool isCompleted;

  Task(
      {this.id,
      required this.title,
      required this.description,
      required this.category,
      required this.priority,
      required this.date,
      required this.isCompleted,
      required this.time});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      taskKeys.title: this.title,
      taskKeys.description: this.description,
      taskKeys.priority: this.priority,
      taskKeys.dateTime: this.date.millisecondsSinceEpoch,
      taskKeys.isCompleted: this.isCompleted,
      taskKeys.time: this.time,
    };

    map.addAll(this.category.toMap());
    return map;
  }

  factory Task.fromMap(QueryDocumentSnapshot map) {
    return Task(
        id: map.id,
        title: map[taskKeys.title],
        description: map[taskKeys.description],
        category: Category.fromMap(map),
        priority: map[taskKeys.priority] as int,
        date:
            DateTime.fromMicrosecondsSinceEpoch(map[taskKeys.dateTime] * 1000),
        isCompleted: map[taskKeys.isCompleted] as bool,
        time: map[taskKeys.time]);
  }
}

class taskKeys {
  static final title = "categoryTitle";
  static final description = "description";
  static final category = "category";
  static final priority = "priority";
  static final dateTime = "date";
  static final isCompleted = "isCompleted";
  static final time = "time";
}
