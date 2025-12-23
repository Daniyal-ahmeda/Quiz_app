import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/core/constants/app_colors.dart';
import 'package:quiz_app/core/constants/app_icons.dart';
import 'package:quiz_app/core/utils/screen_utils.dart';
import 'package:quiz_app/core/widgets/common_button.dart';
import 'package:quiz_app/features/quiz/presentation/pages/home_page.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const ResultScreen({
    Key? key,
    required this.score,
    required this.totalQuestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue2,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'WOW',
                style: GoogleFonts.poppins(
                  fontSize: 69,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: getScreenSize(context).height * 0.03),
              Image.asset(
                AppIcons.eyes,
                height: getScreenSize(context).height * 0.2,
                width: getScreenSize(context).width * 0.4,
              ),
              SizedBox(height: getScreenSize(context).height * 0.05),
              Text(
                'CONGRATS! YOUR SCORE',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '$score/$totalQuestions',
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'You are doing great! Keep learning!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: getScreenSize(context).height * 0.07),
              SizedBox(
                width: double.infinity,
                child: Mainbutton(
                  text: "Home",
                  backgroundColor: Colors.white,
                  textcolor: AppColors.blue2,
                  ontap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
