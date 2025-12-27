import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/core/constants/app_colors.dart';

class DifficultySelector extends StatelessWidget {
  final List<String> difficulties;
  final String currentDifficulty;
  final ValueChanged<String> onDifficultySelected;

  const DifficultySelector({
    super.key,
    required this.difficulties,
    required this.currentDifficulty,
    required this.onDifficultySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final difficulty = difficulties[index];
          final isSelected = difficulty == currentDifficulty;
          return ChoiceChip(
            label: Text(
              difficulty,
              style: GoogleFonts.poppins(
                color: isSelected
                    ? Colors.white
                    : (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black87),
                fontSize: 12,
              ),
            ),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                onDifficultySelected(difficulty);
              }
            },
            selectedColor: AppColors.blue1,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[800]
                : Colors.grey[200],
            padding: const EdgeInsets.symmetric(horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected ? AppColors.blue1 : Colors.transparent,
              ),
            ),
            checkmarkColor: Colors.white,
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemCount: difficulties.length,
      ),
    );
  }
}
