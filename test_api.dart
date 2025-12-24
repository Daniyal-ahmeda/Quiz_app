import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> main() async {
  // Hardcoded key for testing since I can't easily load dotenv in a script without flutter context setup easily
  // Wait, I should try to read the .env file content manually
  final envFile = File('.env');
  if (!envFile.existsSync()) {
    print('Error: .env file not found');
    return;
  }

  final lines = await envFile.readAsLines();
  String apiKey = '';
  for (var line in lines) {
    if (line.startsWith('QUIZ_API_KEY=')) {
      apiKey = line.split('=')[1].trim();
    }
  }

  if (apiKey.isEmpty) {
    print('Error: API key not found in .env');
    return;
  }

  const baseUrl = 'https://quizapi.io/api/v1/questions';
  final categories = ['Linux', 'SQL', 'Docker', 'DevOps'];
  final difficulty = 'Medium'; // Test the problematic one

  for (var category in categories) {
    final url = Uri.parse(
        '$baseUrl?apiKey=$apiKey&category=$category&limit=10&difficulty=$difficulty');
    print('Testing URL: $url');
    try {
      final response = await http.get(url);
      print('Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Items found: ${data.length}');
        if (data.isNotEmpty) {
          print('Sample Q: ${data[0]['question']}');
        }
      } else {
        print('Body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
    print('---');
  }
}
