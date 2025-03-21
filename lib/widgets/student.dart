import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_diu/widgets/auth.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome Student!"),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                imageCache.clear();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Auth()));
              },
              child: Text("Log out"),
            ),
          ],
        ),
      ),
    );
  }
}
