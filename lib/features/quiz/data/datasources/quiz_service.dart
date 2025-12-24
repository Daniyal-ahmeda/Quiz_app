import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/features/quiz/data/models/question_model.dart';
import 'package:quiz_app/features/quiz/data/models/quiz_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class QuizService extends ChangeNotifier {
  List<Quiz> _quizzes = [];
  String _currentDifficulty = 'Any';
  bool _isLoading = false;
  String? _errorMessage;

  List<Quiz> get quizzes => _quizzes;
  String get currentDifficulty => _currentDifficulty;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  QuizService() {
    _loadInitialData();
  }

  static final _apiKey = dotenv.env['QUIZ_API_KEY'] ?? '';
  static const _baseUrl = 'https://quizapi.io/api/v1/questions';

  Future<void> _loadInitialData() async {
    // 1. Load Local JSON
    try {
      if (kDebugMode) print('Loading local quizzes...');
      final String response =
          await rootBundle.loadString('assets/data/quiz_data.json');
      if (kDebugMode) print('JSON loaded. Decoding...');

      final List<dynamic> data = json.decode(response);
      if (kDebugMode) print('JSON decoded. Found ${data.length} items.');

      _quizzes = data.map((json) {
        try {
          return Quiz.fromJson(json);
        } catch (e) {
          if (kDebugMode) print('Error parsing quiz: $e');
          rethrow;
        }
      }).toList();

      if (kDebugMode) print('Local quizzes parsed successfully.');
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('CRITICAL ERROR loading local quizzes: $e');
      }
    }

    // 2. Fetch from API (Independent of local load)
    try {
      if (kDebugMode) print('Fetching API quizzes...');
      await _fetchQuizzesFromApi();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching API quizzes: $e');
      }
    }
  }

  Future<void> _fetchQuizzesFromApi() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final categories = ['Linux', 'SQL', 'Docker', 'DevOps'];
    List<Quiz> newQuizzes = [];

    try {
      if (kDebugMode)
        print('Starting sequential fetch with difficulty: $_currentDifficulty');

      for (var category in categories) {
        try {
          final url = Uri.parse(
            '$_baseUrl?apiKey=$_apiKey&category=$category&limit=10${_currentDifficulty != 'Any' ? '&difficulty=$_currentDifficulty' : ''}',
          );
          if (kDebugMode) print('Fetching URL: $url');
          final response = await http.get(url);

          if (kDebugMode)
            print('Response for $category: ${response.statusCode}');

          if (response.statusCode == 200) {
            final List<dynamic> data = json.decode(response.body);
            if (kDebugMode) print('Data length for $category: ${data.length}');
            if (data.isNotEmpty) {
              final questions = data
                  .map((q) => Question.fromApiJson(q))
                  .where(
                    (q) =>
                        q.question.isNotEmpty &&
                        q.options.isNotEmpty &&
                        q.answer.isNotEmpty,
                  ) // Filter valid questions
                  .toList();

              if (questions.isNotEmpty) {
                newQuizzes.add(
                  Quiz(
                    title: '$category Master',
                    description:
                        'Test your $category skills with these questions.',
                    category: 'Programming',
                    questions: questions,
                  ),
                );
              }
            }
          } else if (response.statusCode == 429) {
            _errorMessage = "Rate limit exceeded. Please wait a moment.";
            if (kDebugMode) print('Rate limit hit for $category');
            // Add a small delay if we hit a rate limit?
            // await Future.delayed(Duration(seconds: 1)); // Maybe?
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error fetching $category quiz: $e');
          }
        }
      }

      if (newQuizzes.isNotEmpty) {
        _quizzes = newQuizzes; // Only replace if we got something
      } else if (_quizzes.isEmpty && _errorMessage == null) {
        // If we got nothing and no error, maybe empty result?
        _errorMessage = "No quizzes found for this difficulty.";
      }
    } catch (e) {
      _errorMessage = "Failed to load quizzes.";
      if (kDebugMode) {
        print('Error in batch fetch: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addQuiz(Quiz quiz) {
    _quizzes.add(quiz);
    notifyListeners();
  }

  void deleteQuiz(String id) {
    _quizzes.removeWhere((q) => q.id == id);
    notifyListeners();
  }

  Future<void> updateDifficulty(String difficulty) async {
    _currentDifficulty = difficulty;
    // Don't clear _quizzes immediately so user still sees old data or just loader on top
    // But if we want to show loading state, we need to handle that.
    // _quizzes = []; // DISABLED CLEARING
    notifyListeners();
    await _fetchQuizzesFromApi();
  }
}
