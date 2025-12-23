import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/core/constants/app_colors.dart';
import 'package:quiz_app/core/services/service_locator.dart';
import 'package:quiz_app/core/widgets/common_button.dart';
import 'package:quiz_app/features/quiz/data/datasources/quiz_service.dart';
import 'package:quiz_app/features/quiz/data/models/question_model.dart';
import 'package:quiz_app/features/quiz/data/models/quiz_model.dart';

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
    showDialog(
      context: context,
      builder: (context) => const AddQuestionDialog(),
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
            content: Text('Please enter a title and at least one question.')),
      );
      return;
    }

    final quiz = Quiz(
      title: _titleController.text,
      description: _descriptionController.text,
      questions: _questions,
    );

    _quizService.addQuiz(quiz);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Quiz',
            style: GoogleFonts.poppins(
                color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Quiz Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Questions (${_questions.length})',
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                    onPressed: _addQuestion,
                    icon: const Icon(Icons.add_circle,
                        color: AppColors.blue2, size: 30)),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final q = _questions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(q.question),
                    subtitle: Text('Answer: ${q.answer}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _questions.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            Mainbutton(
              text: 'Save Quiz',
              ontap: _saveQuiz,
              backgroundColor: AppColors.blue2,
              textcolor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class AddQuestionDialog extends StatefulWidget {
  const AddQuestionDialog({super.key});

  @override
  State<AddQuestionDialog> createState() => _AddQuestionDialogState();
}

class _AddQuestionDialogState extends State<AddQuestionDialog> {
  final _questionController = TextEditingController();
  final _option1Controller = TextEditingController();
  final _option2Controller = TextEditingController();
  final _option3Controller = TextEditingController();
  final _option4Controller = TextEditingController();
  int _correctAnswerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Question'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(labelText: 'Question Text'),
            ),
            const SizedBox(height: 10),
            TextField(
                controller: _option1Controller,
                decoration: const InputDecoration(labelText: 'Option 1')),
            TextField(
                controller: _option2Controller,
                decoration: const InputDecoration(labelText: 'Option 2')),
            TextField(
                controller: _option3Controller,
                decoration: const InputDecoration(labelText: 'Option 3')),
            TextField(
                controller: _option4Controller,
                decoration: const InputDecoration(labelText: 'Option 4')),
            const SizedBox(height: 20),
            const Text('Correct Answer:'),
            DropdownButton<int>(
              value: _correctAnswerIndex,
              items: const [
                DropdownMenuItem(value: 0, child: Text('Option 1')),
                DropdownMenuItem(value: 1, child: Text('Option 2')),
                DropdownMenuItem(value: 2, child: Text('Option 3')),
                DropdownMenuItem(value: 3, child: Text('Option 4')),
              ],
              onChanged: (val) {
                setState(() {
                  _correctAnswerIndex = val!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (_questionController.text.isNotEmpty) {
              final options = [
                _option1Controller.text,
                _option2Controller.text,
                _option3Controller.text,
                _option4Controller.text
              ];
              final q = Question(
                question: _questionController.text,
                options: options,
                answer: options[_correctAnswerIndex],
              );
              Navigator.pop(context, q);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
