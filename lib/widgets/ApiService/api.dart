import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz_diu/widgets/quiz_models.dart';

class ApiService {
  static Future<List<Quiz>> quizes(int userId) async {
    try {
      final response = await http.get(
        Uri.parse("https://shafin1196.pythonanywhere.com/api/all-quiz?teacher=$userId"),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        return parseQuizzes(response.body);
      } else {
        throw Exception('Failed to load quizzes: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('API Error: $error');
    }
  }
  
}