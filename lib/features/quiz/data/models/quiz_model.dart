import 'dart:math';
import 'question_model.dart';

class Quiz {
  String id;
  String title;
  String description;
  String category;
  List<Question> questions;
  DateTime createdAt;

  Quiz({
    String? id,
    required this.title,
    required this.description,
    required this.category,
    required this.questions,
    DateTime? createdAt,
  })  : id = id ?? _generateId(),
        createdAt = createdAt ?? DateTime.now();

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'] ?? 'General',
      questions:
          (json['questions'] as List).map((q) => Question.fromJson(q)).toList(),
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'questions': questions.map((q) => q.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(1000).toString();
  }
}
