import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/core/constants/app_colors.dart';
import 'package:quiz_app/features/quiz/data/models/quiz_model.dart';
import 'package:quiz_app/features/quiz/presentation/pages/result_page.dart';
import 'package:quiz_app/features/quiz/presentation/pages/right_page.dart';
import 'package:quiz_app/features/quiz/presentation/pages/wrong_page.dart';
import 'package:quiz_app/features/quiz/presentation/widgets/choice_tile.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz;
  const QuizScreen({Key? key, required this.quiz}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _selectedChoice = -1;
  int _score = 0;

  void _handleNext() {
    Navigator.pop(context); // Pop Right/Wrong Page
    if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedChoice = -1;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            score: _score,
            totalQuestions: widget.quiz.questions.length,
          ),
        ),
      );
    }
  }

  void _submitAnswer() {
    if (_selectedChoice == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an option'),
          backgroundColor: AppColors.blue2,
        ),
      );
      return;
    }

    final currentQuestion = widget.quiz.questions[_currentQuestionIndex];
    final isCorrect =
        currentQuestion.options[_selectedChoice] == currentQuestion.answer;

    if (isCorrect) {
      _score++;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RightPage(onNext: _handleNext)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WrongPage(onNext: _handleNext)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.quiz.questions.isEmpty) {
      return const Scaffold(body: Center(child: Text('No questions')));
    }

    final currentQuestion = widget.quiz.questions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.quiz.title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Quit',
                style: GoogleFonts.poppins(
                  color: AppColors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 12,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.blue4.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor:
                    (_currentQuestionIndex + 1) / widget.quiz.questions.length,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.blue2,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Question ${_currentQuestionIndex + 1}',
                  style: GoogleFonts.poppins(
                    color: AppColors.blue2,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '/${widget.quiz.questions.length}',
                  style: GoogleFonts.poppins(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[400]
                        : Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            Text(
              currentQuestion.question,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : AppColors.blue1,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.separated(
                itemCount: currentQuestion.options.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) => ChoiceTile(
                  text: currentQuestion.options[index],
                  isSelected: _selectedChoice == index,
                  onTap: () => setState(() {
                    _selectedChoice = index;
                  }),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _submitAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue2,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Confirm Answer',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
