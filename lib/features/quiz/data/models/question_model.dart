import 'dart:math';

class Question {
  String id;
  String question;
  List<String> options = [];
  String answer;

  Question({
    String? id,
    required this.question,
    required this.options,
    required this.answer,
  }) : id = id ?? _generateId();

  static String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(1000).toString();
  }
}
