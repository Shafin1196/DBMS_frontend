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
  final int section;
  final int quizzesAssigned; // For students
  final int coursesAssigned; // For teachers
  final int quizzesCreated;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.section,
    this.quizzesAssigned = 0,
    this.coursesAssigned = 0,
    this.quizzesCreated = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      status: json['status'],
      section: json['section'],
      quizzesAssigned: json['quizzesAssigned'] ?? 0,
      coursesAssigned: json['coursesAssigned'] ?? 0,
      quizzesCreated: json['quizzesCreated'] ?? 0,
    );
  }
}
