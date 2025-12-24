import 'dart:math';
import 'question_model.dart';

class Quiz {
  String id;
  String title;
  String description;
  String category;
  List<Question> questions;

  Quiz({
    String? id,
    required this.title,
    required this.description,
    required this.category,
    required this.questions,
  }) : id = id ?? _generateId();

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'] ?? 'General',
      questions:
          (json['questions'] as List).map((q) => Question.fromJson(q)).toList(),
    );
  }

  static String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(1000).toString();
  }
}
