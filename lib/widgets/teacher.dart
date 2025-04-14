import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:quiz_diu/widgets/add_quiz.dart';
import 'package:quiz_diu/widgets/constrants.dart';
import 'package:quiz_diu/widgets/editQuiz.dart';
import 'package:quiz_diu/widgets/quiz_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_diu/widgets/auth.dart';
import 'package:quiz_diu/widgets/models.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_diu/widgets/profile.dart';
import 'package:quiz_diu/widgets/ApiService/api.dart';


class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({
    super.key,
    required this.user,
    required this.all_quiz,
    required this.teacher,
  });

  final LoginResponse user;
  final Teacher teacher;
  final List<Quiz> all_quiz;

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  // Add a new quiz to the list
  void _addQuiz(Quiz quiz) {
    setState(() {
      widget.all_quiz.add(quiz);
      widget.all_quiz.sort((a, b) => b.quizId.compareTo(a.quizId));
    });
  }

  // Show the Add Quiz overlay
  void _overLay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => AddQuiz(
        userId: widget.user.user.id,
        addQuiz: _addQuiz,
        teacher: widget.teacher,
        all_quiz: widget.all_quiz,
      ),
    );
  }

  // Show confirmation dialog before deleting a quiz
  void _confirmDelete(BuildContext context, int quizId, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Delete Quiz!",
          style: GoogleFonts.roboto(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        elevation: 10,
        shadowColor: Colors.red,
        content: Text("Are you sure you want to delete this quiz?",style:GoogleFonts.roboto(
          color: Colors.black54,
          fontWeight: FontWeight.bold,
        ) ,),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close dialog
              await _deleteQuiz(quizId, index);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  // Delete a quiz and update the UI
Future<void> _deleteQuiz(int quizId, int index) async {
  try {
    await ApiService.deleteQuiz(quizId);
    setState(() {
      widget.all_quiz.removeAt(index); // Remove quiz from the list
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Quiz deleted successfully!")),
    );
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(" ${error.toString()}")),
    );
    print("Error deleting quiz: $error"); // Log the error for debugging
  }
}
  @override
  void initState() {
    super.initState();
    widget.all_quiz.sort((a, b) => b.quizId.compareTo(a.quizId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeData().colorScheme.primaryContainer,
      body: Container(
        margin: EdgeInsets.only(top: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.user,
                    size: 25,
                    color: const Color.fromARGB(255, 10, 10, 8),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(user: widget.user),
                      ),
                    );
                  },
                ),
                SizedBox(width: 5),
                Expanded(
                  flex: 6,
                  child: Text(
                    widget.user.user.name,
                    style: GoogleFonts.permanentMarker(
                        fontSize: 25, fontWeight: FontWeight.bold,),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Spacer(),
                CircleAvatar(
                  //backgroundColor: const Color.fromARGB(255, 201, 200, 195),
                  child: IconButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      imageCache.clear();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Auth(
                            message: "Log out successfully!",
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      FontAwesomeIcons.signOutAlt,
                      size: 25,
                      color: const Color.fromARGB(255, 10, 10, 8),
                    ),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
            // Quiz List
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 20),
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Colors.white,
                ),
                child: widget.all_quiz.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.solidMeh,
                              size: 100,
                              color: Colors.amberAccent.shade700,
                            ),
                            Text(
                              "No Quiz Found",
                              style: GoogleFonts.roboto(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Click ",
                                  style: GoogleFonts.roboto(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 30,
                                    color: Colors.amberAccent.shade700,
                                  ),
                                ),
                                Text(
                                  " to add Quiz",
                                  style: GoogleFonts.roboto(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: widget.all_quiz.length,
                        itemBuilder: (context, index) {
                          final quiz = widget.all_quiz[index];
                          return Card(
                            borderOnForeground: false,
                            elevation: 10,
                            margin: EdgeInsets.all(10),
                            shadowColor: Colors.yellow,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: ListTile(
                              title: Text(
                                quiz.quizName,
                                style: GoogleFonts.roboto(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      quiz.course.courseName,
                                      style: cardTextStyle,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  Spacer(),
                                  Expanded(
                                    child: Text(
                                      quiz.section.sectionName,
                                      style: cardTextStyle,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(FontAwesomeIcons.trash, color: Colors.red,size: 30,),
                                    onPressed: () {
                                      _confirmDelete(context, quiz.quizId, index);
                                    },
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditQuiz(
                                            quiz: quiz,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      FontAwesomeIcons.edit,
                                      size: 30,
                                      color: Colors.amberAccent.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).animate().fadeIn(duration: 500.ms).slide(
                              begin: Offset(1, 0),
                              end: Offset(0, 0),
                              duration: 500.ms);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 40,
        width: 40,
        child: FloatingActionButton(
          onPressed: () {
            _overLay();
          },
          backgroundColor: Colors.black12,
          focusElevation: 10,
          autofocus: true,
          elevation: 6,
          hoverElevation: 10,
          hoverColor: Colors.red,
          child: Icon(
            Icons.add,
            color: Colors.amberAccent.shade700,
            size: 40,
          ),
        ),
      ),
    );
  }
}