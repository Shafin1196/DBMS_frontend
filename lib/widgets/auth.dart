import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_diu/widgets/quiz_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_diu/widgets/teacher.dart';
import 'package:quiz_diu/widgets/student.dart';
import 'package:quiz_diu/widgets/ApiService/api.dart';
import 'models.dart';

class Auth extends StatefulWidget {
  final String message;
  const Auth({super.key, this.message = ""});
  @override
  State<Auth> createState() {
    return _AuthState();
  }
}

class _AuthState extends State<Auth> with SingleTickerProviderStateMixin {
  final _emailControl = TextEditingController();
  final _passControl = TextEditingController();
  bool isLoading = false;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutSine,
      ),
    );
    _slideAnimation = Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastEaseInToSlowEaseOut,
      ),
    );
    _controller.forward();

    if (widget.message.isNotEmpty) {
      Future.microtask(() {
        _showError(widget.message);
      });
    }
  }

  Future<void> _submit() async {
    final String email = _emailControl.text;
    final String password = _passControl.text;

    if (email.isEmpty || password.isEmpty) {
      _showError("Email and password cannot be empty!");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("https://shafin1196.pythonanywhere.com/api/login/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final LoginResponse loginResponse = LoginResponse.fromJson(responseData);
        _showError(loginResponse.message);
        // Save user data locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('message', loginResponse.message);
        await prefs.setInt('user_id', loginResponse.user.id);
        await prefs.setString('user_name', loginResponse.user.name);
        await prefs.setString('user_email', loginResponse.user.email);
        await prefs.setString('user_status', loginResponse.user.status);
        await prefs.setInt('user_section', loginResponse.user.section);
        List<Quiz> quizList = await ApiService.quizes(loginResponse);
        // Navigate based on user role
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => loginResponse.user.status == "Teacher"
                ? TeacherHomeScreen(user: loginResponse, all_quiz: quizList,)
                : StudentHomeScreen(user: loginResponse, all_quiz: quizList,),
          ),
        );
      } else {
        _showError("Invalid email or password!");
      }
    } catch (error) {
      _showError("Network error! Please try again.");
    }

    setState(() {
      isLoading = false;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  void dispose() {
    _emailControl.dispose();
    _passControl.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                "assets/gifs/quizp.gif",
                width: 400,
                key: UniqueKey(),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) => FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: child,
                    ),
                  ),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: _emailControl,
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              decoration: InputDecoration(
                                label: Text(
                                  "Email",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.scrim,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _passControl,
                              obscureText: true,
                              decoration: InputDecoration(
                                label: Text(
                                  "Password",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.scrim,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amberAccent,
                              ),
                              child: Text(
                                "Log in",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.scrim,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}