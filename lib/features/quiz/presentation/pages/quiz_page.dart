import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/core/constants/app_colors.dart';
import 'package:quiz_app/core/utils/screen_utils.dart';
import 'package:quiz_app/core/widgets/common_button.dart';
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
    if (_selectedChoice == -1) return;

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.quiz.title,
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / widget.quiz.questions.length,
              backgroundColor: AppColors.blue4,
              minHeight: 17,
              color: AppColors.blue2,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  '${_currentQuestionIndex + 1}/',
                  style: const TextStyle(
                      color: AppColors.blue2,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                Text(
                  widget.quiz.questions.length.toString(),
                  style: const TextStyle(
                      color: AppColors.blue4,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                )
              ],
            ),
            const SizedBox(height: 20),
            Text(
              currentQuestion.question,
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: getScreenSize(context).height * 0.05),
            Expanded(
              child: ListView.builder(
                itemCount: currentQuestion.options.length,
                itemBuilder: (context, index) => ChoiceTile(
                  text: currentQuestion.options[index],
                  isSelected: _selectedChoice == index,
                  onTap: () => setState(() {
                    _selectedChoice = index;
                  }),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: Mainbutton(
                text: 'Next',
                ontap: _submitAnswer,
                backgroundColor: AppColors.blue2,
                textcolor: Colors.white,
                paddingbutten: const EdgeInsets.symmetric(vertical: 16.0),
                textsize: 16.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
