import 'dart:math';
import 'question_model.dart';

class Quiz {
  String id;
  String title;
  String description;
  List<Question> questions;

  Quiz({
    String? id,
    required this.title,
    required this.description,
    required this.questions,
  }) : id = id ?? _generateId();

  static String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(1000).toString();
  }
}
