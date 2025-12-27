import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/core/constants/app_colors.dart';
import 'package:quiz_app/core/utils/screen_utils.dart';
import 'package:quiz_app/core/widgets/common_button.dart';
import 'package:quiz_app/features/auth/presentation/pages/login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(height: getScreenSize(context).height * 0.05),
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: AppColors.blue4.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.science_rounded,
                    size: 100,
                    color: AppColors.blue2,
                  ),
                ),
                SizedBox(height: getScreenSize(context).height * 0.03),
                Text(
                  'Scientific Quizzes',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blue1,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: getScreenSize(context).height * 0.02),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.blue2,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: getScreenSize(context).height * 0.065),
                  Text(
                    'Test Your Knowledge on Mobile Development Evolution!',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: getScreenSize(context).height * 0.05),
                  Text(
                    'Flutter revolutionized mobile development by enabling a single codebase for multiple platforms.',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: getScreenSize(context).height * 0.07),
                  Mainbutton(
                    text: 'Get Started',
                    textsize: 16,
                    backgroundColor: Colors.white,
                    textcolor: AppColors.blue2,
                    paddingbutten: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 15,
                    ),
                    ontap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
