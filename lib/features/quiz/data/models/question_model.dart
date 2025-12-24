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

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'].toString(),
      question: json['question'],
      options: List<String>.from(json['options']),
      answer: json['answer'],
    );
  }

  factory Question.fromApiJson(Map<String, dynamic> json) {
    final Map<String, dynamic> answers = json['answers'];
    final Map<String, dynamic> correctAnswers = json['correct_answers'];

    // Extract valid options (non-null)
    final List<String> options = [];
    String correctKey = '';

    answers.forEach((key, value) {
      if (value != null) {
        options.add(value.toString());
        // Check if this key corresponds to a correct answer
        // API keys are like "answer_a", correct keys are "answer_a_correct"
        if (correctAnswers['${key}_correct'] == 'true') {
          correctKey = key;
        }
      }
    });

    String correctAnswerText = '';
    if (correctKey.isNotEmpty && answers[correctKey] != null) {
      correctAnswerText = answers[correctKey].toString();
    } else if (options.isNotEmpty) {
      // Fallback if no correct answer marked (rare but possible)
      correctAnswerText = options.first;
    }

    return Question(
      id: json['id'].toString(),
      question: json['question'],
      options: options,
      answer: correctAnswerText,
    );
  }

  static String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(1000).toString();
  }
}
