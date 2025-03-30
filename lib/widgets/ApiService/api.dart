import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz_diu/widgets/models.dart';
import 'package:quiz_diu/widgets/quiz_models.dart';

class ApiService {
  static Future<List<Quiz>> quizes(LoginResponse user) async {
    try {
      if (user.user.status == "Teacher") {
        final response = await http.get(
          Uri.parse(
              "https://shafin1196.pythonanywhere.com/api/all-quiz?teacher=${user.user.id}"),
          headers: {"Content-Type": "application/json"},
        );
        if (response.statusCode == 200) {
          return parseQuizzes(response.body);
        } else {
          throw Exception('Failed to load quizzes: ${response.statusCode}');
        }
      } else if (user.user.status == "Student") {
        final response = await http.get(
          Uri.parse(
              "https://shafin1196.pythonanywhere.com/api/all-quiz?section=${user.user.section}"),
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

// get teacher infromations
  static Future<Teacher> teacher(int userId) async {
    try {
      final response = await http.get(
        Uri.parse(
            "https://shafin1196.pythonanywhere.com/api/all/teacher/$userId"),
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

  // create new quiz
  static Future<Quiz> createQuiz(CreateQuiz quiz) async {
    try {
      final response = await http.post(
        Uri.parse("https://shafin1196.pythonanywhere.com/api/create-quiz/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(quiz.toJson()),
      );
      if (response.statusCode == 201) {
        return Quiz.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create quiz: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('API Error: $error');
    }
  }

  //create new questions
  static Future<QuizQuestion> createQuestion(CreateQuestion question) async {
    try {
      final response = await http.post(
        Uri.parse("https://shafin1196.pythonanywhere.com/api/create-question/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(question.toJson()),
      );
      if (response.statusCode == 201) {
        return QuizQuestion.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create questions: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('API Error: $error');
    }
  }

  // create answer
  static Future<QuizAnswer> createAnswer(CreateAnswer answer) async {
    try {
      final response = await http.post(
        Uri.parse("https://shafin1196.pythonanywhere.com/api/create-answer/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(answer.toJson()),
      );
      if (response.statusCode == 201) {
        return QuizAnswer.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create answers: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('API Error: $error');
    }
  }

  //create result
  static Future<bool> createResult(Result result) async {
    try {
      final response = await http.post(
        Uri.parse("https://shafin1196.pythonanywhere.com/api/create-result/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(result.toJson()),
      );
      print(jsonEncode(result.toJson()));
      if (response.statusCode == 201) {
        print("Successfully submitted");
        return true; // Indicate success
      } else {
        print('Failed to create result: ${response.statusCode}');
        return false; // Indicate failure
      }
    } catch (error) {
      return false; // Indicate failure
    }
  }

  //get quizId
  static Future<int> getQuizId() async {
    try {
      final response = await http.get(
        Uri.parse("https://shafin1196.pythonanywhere.com/api/next-quiz-id/"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['quiz_id']; // Extracting the quiz_id from the response
      } else {
        throw Exception('Failed to fetch quiz_id: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('API Error: $error');
    }
  }

//get question id
  static Future<int> getQuestionId() async {
    try {
      final response = await http.get(
        Uri.parse(
            "https://shafin1196.pythonanywhere.com/api/next-question-id/"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['question_id'];
      } else {
        throw Exception('Failed to fetch question_id: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('API Error: $error');
    }
  }

//get answer id
  static Future<int> getAnswerId() async {
    try {
      final response = await http.get(
        Uri.parse("https://shafin1196.pythonanywhere.com/api/next-answer-id/"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['answer_id']; // Extracting the quiz_id from the response
      } else {
        throw Exception('Failed to fetch question_id: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('API Error: $error');
    }
  }
//get result
  static Future<dynamic> getResult(int studentId, int quizId) async {
    print("s-id:${studentId}");
    print("q-id${quizId}");
    try {
      final response = await http.get(
        Uri.parse(
            "https://shafin1196.pythonanywhere.com/api/get-result/?student=${studentId}&quiz=${quizId}"),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } 
      else if(response.statusCode==404){
        return false;
      }
      else {
        throw Exception('Failed to fetch question_id: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('API Error: $error');
    }
  }
}
