import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/core/constants/app_colors.dart';
import 'package:quiz_app/core/services/service_locator.dart';
import 'package:quiz_app/features/quiz/data/datasources/quiz_service.dart';
import 'package:quiz_app/features/quiz/presentation/pages/create_quiz_page.dart';
import 'package:quiz_app/features/quiz/presentation/pages/quiz_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final quizService = locator<QuizService>();

  @override
  void initState() {
    super.initState();
    quizService.addListener(_update);
  }

  @override
  void dispose() {
    quizService.removeListener(_update);
    super.dispose();
  }

  void _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scientific Quizzes',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: AppColors.blue2,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: quizService.quizzes.isEmpty
          ? Center(
              child: Text(
                'No quizzes available. Create one!',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: quizService.quizzes.length,
              itemBuilder: (context, index) {
                final quiz = quizService.quizzes[index];
                return Dismissible(
                  key: Key(quiz.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    quizService.deleteQuiz(quiz.id);
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        quiz.title,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blue2,
                        ),
                      ),
                      subtitle: Text(
                        quiz.description,
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: AppColors.blue2),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizScreen(quiz: quiz),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateQuizPage()),
          );
        },
        backgroundColor: AppColors.blue2,
        child: const Icon(Icons.add),
      ),
    );
  }
}
