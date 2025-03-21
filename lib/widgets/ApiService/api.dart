import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz_diu/widgets/models.dart';
import 'package:quiz_diu/widgets/quiz_models.dart';

class ApiService {
  static Future<List<Quiz>> quizes(LoginResponse user) async {
    try {
      if(user.user.status=="Teacher"){
        final response = await http.get(
          Uri.parse("https://shafin1196.pythonanywhere.com/api/all-quiz?teacher=${user.user.id}"),
          headers: {"Content-Type": "application/json"},
        );
        if (response.statusCode == 200) {
          return parseQuizzes(response.body);
        } else {
          throw Exception('Failed to load quizzes: ${response.statusCode}');
        }
      }
      else if(user.user.status=="Student"){
        final response = await http.get(
          Uri.parse("https://shafin1196.pythonanywhere.com/api/all-quiz?section=${user.user.section}"),
          headers: {"Content-Type": "application/json"},
        );
        if (response.statusCode == 200) {
          return parseQuizzes(response.body);
        } else {
          throw Exception('Failed to load quizzes: ${response.statusCode}');
        }
      }
    } catch (error) {
      throw Exception('API Error: $error');
    }
    throw Exception('Invalid user status: ${user.user.status}');
  }

  static Future<Teacher> teacher(int userId) async {
    try {
      final response = await http.get(
        Uri.parse("https://shafin1196.pythonanywhere.com/api/all/teacher/$userId"),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        return Teacher.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load teacher: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('API Error: $error');
    }
  }
  
}