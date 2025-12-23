import 'package:get_it/get_it.dart';
import 'package:quiz_app/features/quiz/data/datasources/quiz_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton(QuizService());
}
