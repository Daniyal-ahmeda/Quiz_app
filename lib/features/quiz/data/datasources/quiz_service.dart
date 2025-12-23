import 'package:flutter/foundation.dart';
import 'package:quiz_app/features/quiz/data/models/question_model.dart';
import 'package:quiz_app/features/quiz/data/models/quiz_model.dart';

class QuizService extends ChangeNotifier {
  List<Quiz> _quizzes = [
    Quiz(
      title: 'Flutter Basics',
      description: 'Test your knowledge on Flutter history and basics.',
      questions: [
        Question(
          answer: '2017',
          question: 'When was Flutter introduced by Google?',
          options: ['2015', '2017', '2018', '2019'],
        ),
        Question(
          answer: '1.0.0',
          question: 'What is the latest version of Flutter?',
          options: ['1.0.0', '1.5.4', '2.0.0', '2.2.0'],
        ),
        Question(
          answer: 'Dart',
          question: 'What is the programming language used in Flutter?',
          options: ['Dart', 'Java', 'Kotlin', 'Swift'],
        ),
        Question(
          answer: 'Sky',
          question: 'What is the name of the first Flutter stable version?',
          options: ['Sky', 'Star', 'Sun', 'Moon'],
        ),
      ],
    )
  ];

  List<Quiz> get quizzes => _quizzes;

  void addQuiz(Quiz quiz) {
    _quizzes.add(quiz);
    notifyListeners();
  }

  void deleteQuiz(String id) {
    _quizzes.removeWhere((q) => q.id == id);
    notifyListeners();
  }
}
