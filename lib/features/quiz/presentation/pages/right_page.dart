import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:quiz_app/core/constants/app_colors.dart';
import 'package:quiz_app/core/constants/app_icons.dart';
import 'package:quiz_app/core/utils/screen_utils.dart';
import 'package:quiz_app/core/widgets/common_button.dart';

class RightPage extends StatelessWidget {
  final VoidCallback onNext;
  const RightPage({required this.onNext, super.key});

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();
    player.play(AssetSource('audio/correct.mp3'));
    return Scaffold(
      backgroundColor: AppColors.green,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(AppIcons.right),
                width: getScreenSize(context).width * 0.5,
                height: getScreenSize(context).height * 0.3,
              ),
              Text(
                'Great job! You  \n   got it right!',
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: getScreenSize(context).height * 0.2),
              SizedBox(
                width: double.infinity,
                child: Mainbutton(
                  text: 'Next',
                  textsize: 20,
                  paddingbutten: const EdgeInsets.symmetric(vertical: 8.0),
                  ontap: onNext,
                  textcolor: AppColors.green,
                  backgroundColor: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
