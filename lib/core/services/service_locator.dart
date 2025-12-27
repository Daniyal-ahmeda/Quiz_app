import 'package:get_it/get_it.dart';
import 'package:quiz_app/features/quiz/data/datasources/quiz_service.dart';
import 'package:quiz_app/features/auth/data/auth_service.dart';
import 'package:quiz_app/features/profile/data/character_repository.dart';
import 'package:quiz_app/core/services/theme_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  final prefs = await SharedPreferences.getInstance();
  locator.registerSingleton<SharedPreferences>(prefs);
  locator.registerSingleton(ThemeService(prefs));
  locator.registerSingleton(QuizService());
  locator.registerSingleton(AuthService());
  locator.registerSingleton(CharacterRepository());
}
