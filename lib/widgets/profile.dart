import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_diu/widgets/models.dart';

class ProfileScreen extends StatelessWidget {
  final LoginResponse user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Common Profile Details
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.amber,
              child: Icon(
                Icons.person,
                size: 50,
                color: const Color.fromARGB(255, 17, 15, 15),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Name: ${user.user.name}",
              style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white,),
            ),
            SizedBox(height: 8),
            Text(
              "Email: ${user.user.email}",
              style: GoogleFonts.roboto(fontSize: 16,color: Colors.white,),
            ),
            SizedBox(height: 8),
            Text(
              "Role: ${user.user.status}",
              style: GoogleFonts.roboto(fontSize: 16,color: Colors.white,),
            ),
            SizedBox(height: 16),

            // Role-Specific Details
            if (user.user.status == "Student") ...[
              Text(
                "Section: ${user.user.section}",
                style: GoogleFonts.roboto(fontSize: 16, color: Colors.white,),
              ),
              SizedBox(height: 8),
              Text(
                "Quizzes Assigned: ${user.user.quizzesAssigned}",
                style: GoogleFonts.roboto(fontSize: 16, color: Colors.white,),
              ),
            ] else if (user.user.status == "Teacher") ...[
              Text(
                "Courses Assigned: ${user.user.coursesAssigned}",
                style: GoogleFonts.roboto(fontSize: 16, color: Colors.white,),
              ),
              SizedBox(height: 8),
              Text(
                "Quizzes Created: ${user.user.quizzesCreated}",
                style: GoogleFonts.roboto(fontSize: 16, color: Colors.white,),
              ),
            ],
          ],
        ),
      ),
    );
  }
}