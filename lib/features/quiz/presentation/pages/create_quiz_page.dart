import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/core/constants/app_colors.dart';
import 'package:quiz_app/core/services/service_locator.dart';
import 'package:quiz_app/core/widgets/common_button.dart';
import 'package:quiz_app/features/quiz/data/datasources/quiz_service.dart';
import 'package:quiz_app/features/quiz/data/models/question_model.dart';
import 'package:quiz_app/features/quiz/data/models/quiz_model.dart';
import 'package:quiz_app/features/quiz/presentation/widgets/add_question_sheet.dart';
import 'package:quiz_app/features/quiz/presentation/widgets/question_list_item.dart';
import 'package:quiz_app/features/quiz/presentation/widgets/quiz_text_field.dart';

class CreateQuizPage extends StatefulWidget {
  const CreateQuizPage({super.key});

  @override
  State<CreateQuizPage> createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<Question> _questions = [];

  final _quizService = locator<QuizService>();

  void _addQuestion() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddQuestionSheet(),
    ).then((value) {
      if (value != null && value is Question) {
        setState(() {
          _questions.add(value);
        });
      }
    });
  }

  void _saveQuiz() {
    if (_titleController.text.isEmpty || _questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title and at least one question.'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    final quiz = Quiz(
      title: _titleController.text,
      description: _descriptionController.text,
      category: 'General',
      questions: _questions,
    );

    _quizService.addQuiz(quiz);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Quiz',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Quiz Details'),
            const SizedBox(height: 10),
            QuizTextField(
              controller: _titleController,
              label: 'Quiz Title',
              icon: Icons.title,
            ),
            const SizedBox(height: 16),
            QuizTextField(
              controller: _descriptionController,
              label: 'Description',
              icon: Icons.description,
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader('Questions (${_questions.length})'),
                TextButton.icon(
                  onPressed: _addQuestion,
                  icon: const Icon(Icons.add_circle, color: AppColors.blue2),
                  label: Text(
                    'Add New',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: AppColors.blue2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (_questions.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Icon(Icons.quiz_outlined,
                        size: 60, color: Colors.grey.shade300),
                    const SizedBox(height: 10),
                    Text(
                      'No questions added yet',
                      style: GoogleFonts.poppins(
                          color: Colors.grey.shade500, fontSize: 16),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  return QuestionListItem(
                    question: _questions[index],
                    index: index,
                    onDelete: () {
                      setState(() {
                        _questions.removeAt(index);
                      });
                    },
                  );
                },
              ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: Mainbutton(
                text: 'Save Quiz',
                ontap: _saveQuiz,
                backgroundColor: AppColors.blue2,
                textcolor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.blue1,
      ),
    );
  }
}
