import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app/features/quiz/data/models/quiz_model.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

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
    _listenToQuizzes();
  }

  void _listenToQuizzes() {
    _isLoading = true;
    notifyListeners();

    try {
      FirebaseFirestore.instance
          .collection('quizzes')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.docs.isEmpty && !_isLoading) {
          // Auto-seed if empty
          _seedInitialData();
        }

        _quizzes = snapshot.docs.map((doc) {
          final data = doc.data();
          // Ensure ID matches doc ID if consistent, or just use data's ID
          data['id'] = doc.id;
          return Quiz.fromJson(data);
        }).toList();

        // Apply local filtering if needed, though Firestore queries are better
        if (_currentDifficulty != 'Any') {
          // Note: Real filtering should probably happen in the query for efficiency,
          // but for dynamic checking without complex indexes, local filter is fine for small apps.
          // _quizzes = _quizzes.where(...)
          // However, our Quiz model doesn't store difficulty at top level,
          // it was based on Question difficulty.
          // For now, we will return ALL quizzes or filter by category if we add category selection back.
        }

        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      }, onError: (e) {
        _errorMessage = "Failed to load quizzes: $e";
        _isLoading = false;
        notifyListeners();
        if (kDebugMode) print("Firestore Error: $e");
      });
    } catch (e) {
      _errorMessage = "Error initializing listener: $e";
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _seedInitialData() async {
    try {
      if (kDebugMode) print("Seeding initial data...");
      // Check if we already seeded to avoid race conditions (double check)
      final check =
          await FirebaseFirestore.instance.collection('quizzes').limit(1).get();
      if (check.docs.isNotEmpty) return;

      final String response =
          await rootBundle.loadString('assets/data/quiz_data.json');
      final List<dynamic> data = json.decode(response);

      final batch = FirebaseFirestore.instance.batch();

      for (var jsonItem in data) {
        final docRef = FirebaseFirestore.instance.collection('quizzes').doc();
        // Ensure createdAt is present
        jsonItem['createdAt'] = DateTime.now().toIso8601String();
        batch.set(docRef, jsonItem);
      }

      await batch.commit();
      if (kDebugMode) print("Seeding complete!");
    } catch (e) {
      if (kDebugMode) print("Error seeding data: $e");
    }
  }

  Future<void> addQuiz(Quiz quiz) async {
    try {
      await FirebaseFirestore.instance.collection('quizzes').add(quiz.toJson());
    } catch (e) {
      if (kDebugMode) print("Error adding quiz: $e");
      rethrow;
    }
  }

  Future<void> deleteQuiz(String id) async {
    try {
      // If we use the document ID as the Quiz ID
      await FirebaseFirestore.instance.collection('quizzes').doc(id).delete();

      // If the Quiz ID ID is stored as a field 'id' but not the doc ID, query it
      // final query = await FirebaseFirestore.instance.collection('quizzes').where('id', isEqualTo: id).get();
      // for (var doc in query.docs) { await doc.reference.delete(); }
    } catch (e) {
      if (kDebugMode) print("Error deleting quiz: $e");
      rethrow;
    }
  }

  Future<void> updateDifficulty(String difficulty) async {
    _currentDifficulty = difficulty;
    notifyListeners();
    // In this new architecture, we might just filter the list locally
    // since we are streaming all quizzes.
    // Or restart the listener with a where() clause if we add 'difficulty' to top-level Quiz model.
  }
}
