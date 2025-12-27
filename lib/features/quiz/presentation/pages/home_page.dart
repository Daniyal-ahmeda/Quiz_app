import 'package:flutter/material.dart';
import 'package:quiz_app/core/services/service_locator.dart';
import 'package:quiz_app/core/constants/app_colors.dart';
import 'package:quiz_app/core/services/theme_service.dart';
import 'package:quiz_app/features/quiz/data/datasources/quiz_service.dart';
import 'package:quiz_app/features/quiz/data/models/quiz_model.dart';
import 'package:quiz_app/features/quiz/presentation/pages/create_quiz_page.dart';
import 'package:quiz_app/features/quiz/presentation/widgets/category_selector.dart';
import 'package:quiz_app/features/quiz/presentation/widgets/difficulty_selector.dart';
import 'package:quiz_app/features/quiz/presentation/widgets/quiz_list.dart';
import 'package:quiz_app/features/profile/presentation/pages/profile_page.dart';
import 'package:quiz_app/features/quiz/presentation/widgets/quiz_text_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final quizService = locator<QuizService>();
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Programming', 'Science', 'History'];
  final List<String> _difficulties = ['Any', 'Easy', 'Medium', 'Hard'];

  @override
  void initState() {
    super.initState();
    quizService.addListener(_update);
    _searchController.addListener(_update);
  }

  @override
  void dispose() {
    quizService.removeListener(_update);
    _searchController.dispose();
    super.dispose();
  }

  void _update() {
    setState(() {});
  }

  List<Quiz> get _filteredQuizzes {
    var quizzes = quizService.quizzes;

    // Filter by Category
    if (_selectedCategory != 'All') {
      quizzes = quizzes.where((q) => q.category == _selectedCategory).toList();
    }

    // Filter by Search Query
    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      quizzes =
          quizzes.where((q) => q.title.toLowerCase().contains(query)).toList();
    }

    return quizzes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi, User 👋",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              "Let's make this day productive",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()));
            },
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                locator<ThemeService>().isDarkMode
                    ? Icons.light_mode
                    : Icons.dark_mode,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              onPressed: () {
                locator<ThemeService>().toggleTheme();
              },
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: QuizTextField(
              controller: _searchController,
              label: "Search Quizzes",
              icon: Icons.search,
              hint: "Try 'Flutter' or 'Science'...",
            ),
          ),
          CategorySelector(
            categories: _categories,
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
          DifficultySelector(
            difficulties: _difficulties,
            currentDifficulty: quizService.currentDifficulty,
            onDifficultySelected: (difficulty) {
              quizService.updateDifficulty(difficulty);
            },
          ),
          Expanded(
            child: QuizList(
              isLoading: quizService.isLoading,
              errorMessage: quizService.errorMessage,
              quizzes: _filteredQuizzes,
              onRetry: () {
                quizService.updateDifficulty(quizService.currentDifficulty);
              },
              onDeleteQuiz: (quizId) {
                quizService.deleteQuiz(quizId);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateQuizPage()),
          );
        },
        backgroundColor: AppColors.blue2,
        elevation: 4,
        child: const Icon(Icons.add_rounded, size: 32, color: Colors.white),
      ),
    );
  }
}
