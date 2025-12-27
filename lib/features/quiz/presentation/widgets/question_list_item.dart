import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/core/constants/app_colors.dart';
import 'package:quiz_app/features/quiz/data/models/question_model.dart';

class QuestionListItem extends StatelessWidget {
  final Question question;
  final int index;
  final VoidCallback onDelete;

  const QuestionListItem({
    super.key,
    required this.question,
    required this.index,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.blue4.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              color: AppColors.blue2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          question.question,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            'Answer: ${question.answer}',
            style: TextStyle(color: Colors.green[700]),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: AppColors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
