class LoginResponse {
  final String message;
  final User user;

  LoginResponse({required this.message, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String status;

  User({required this.id,required this.name, required this.email, required this.status});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      status: json['status'],
    );
  }
}

class DQuiz {
  final int id;
  final String quizName;
  final String course_name;
  final String section_name;
  final DateTime start_time;
  final DateTime end_time;
  const DQuiz({
    required this.id,
    required this.quizName,
    required this.course_name,
    required this.section_name,
    required this.start_time,
    required this.end_time,
  });
}