import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_diu/widgets/ApiService/api.dart';
import 'package:quiz_diu/widgets/constrants.dart';
import 'package:quiz_diu/widgets/models.dart';
import 'package:quiz_diu/widgets/quiz.dart';
import 'package:quiz_diu/widgets/quiz_models.dart';
import 'package:quiz_diu/widgets/studentResult.dart';
import 'package:quiz_diu/widgets/timer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_diu/widgets/auth.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen(
      {super.key, required this.user, required this.all_quiz});
  final LoginResponse user;
  final List<Quiz> all_quiz;
  @override
  State<StudentHomeScreen> createState() => _StudentState();
}

class _StudentState extends State<StudentHomeScreen> {
  List<Quiz> all_quiz = [];
  bool isRefreshing = false;
  @override
  void initState() {
    super.initState();
    all_quiz = widget.all_quiz;
    all_quiz.sort((a, b) => b.startTime.compareTo(a.startTime));
  }

  void refresh() async {
    setState(() {
      isRefreshing = true;
    });
    final quizzes = await ApiService.quizes(widget.user);
    setState(() {
      all_quiz = quizzes;
      all_quiz.sort((a, b) => b.quizId.compareTo(a.quizId));
      isRefreshing = false;
    });

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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.yellow,
                  child: Icon(Icons.person,
                      size: 25, color: const Color.fromARGB(255, 10, 10, 8)),
                ),
                SizedBox(width: 5),
                Expanded(
                  flex: 8,
                  child: Text(
                    (widget.user.user.name),
                    style: GoogleFonts.permanentMarker(
                        fontSize: 25, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Spacer(),
                CircleAvatar(
                  backgroundColor: Colors.yellow,
                  child: IconButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      // ignore: use_build_context_synchronously
                      imageCache.clear();
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Auth(
                                    message: "log out successfully!",
                                  )));
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
            SizedBox(height: 20),
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
                child: all_quiz.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.solidFaceGrin,
                              size: 100,
                              color: Colors.amberAccent.shade700,
                            ),
                            Text(
                              "There is no quiz for you!!",
                              style: GoogleFonts.roboto(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: all_quiz.length,
                        itemBuilder: (context, index) {
                          return Card(
                            borderOnForeground: false,
                            elevation: 10,
                            margin: EdgeInsets.all(10),
                            shadowColor: Colors.yellow,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: ListTile(
                                title: Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      all_quiz[index].quizName,
                                      style: GoogleFonts.roboto(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ],
                                ),
                                subtitle: Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      all_quiz[index].course.courseName,
                                      style: cardTextStyle,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    )),
                                    Spacer(),
                                    Expanded(
                                        child: Text(
                                      all_quiz[index].section.sectionName,
                                      style: cardTextStyle,
                                    )),
                                  ],
                                ),
                                trailing: all_quiz[index]
                                        .startTime
                                        .isAfter(DateTime.now())
                                    ?
                                    // starts in
                                    ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              ThemeData().colorScheme.scrim,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.clock,
                                              color: Colors.white,
                                            ),
                                            TimeRemainingPage(
                                              endTime: all_quiz[index].endTime,
                                              onText: TimerOnButtonTextStyle,
                                            ),
                                          ],
                                        ),
                                      )
                                    //start button
                                    : (all_quiz[index]
                                                .startTime
                                                .isBefore(DateTime.now()) &&
                                            all_quiz[index]
                                                .endTime
                                                .isAfter(DateTime.now()))
                                        ? ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          QuizScreen(
                                                            quiz:
                                                                all_quiz[index],
                                                            user_id: widget
                                                                .user.user.id,
                                                          )));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  ThemeData().colorScheme.scrim,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Start",
                                                  style: GoogleFonts.roboto(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Icon(
                                                  FontAwesomeIcons.arrowRight,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          )
                                        //result button
                                        : ElevatedButton(
                                            onPressed: () async {
                                              final data =
                                                  await ApiService.getResult(
                                                      widget.user.user.id,
                                                      widget.all_quiz[index]
                                                          .quizId);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ResultScreen(
                                                            data: data,
                                                            totalMarks: widget
                                                                .all_quiz[index]
                                                                .quiz_marks,
                                                          )));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  ThemeData().colorScheme.scrim,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Results",
                                                  style: GoogleFonts.roboto(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Icon(
                                                  FontAwesomeIcons.trophy,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          )),
                          )
                              .animate()
                              .fadeIn(
                                  duration: 500.ms,
                                  curve: Curves.easeIn) // Fade-in animation
                              .slide(
                                  begin: Offset(1, 0),
                                  end: Offset(0, 0),
                                  duration: 500.ms); // Slide-in from right
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: isRefreshing
          ? FloatingActionButton(
              onPressed: null, // Disable button while refreshing
              backgroundColor: Colors.black12, // Indicate disabled state
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.amber.shade700),
              ),
            )
          : FloatingActionButton(
              onPressed: refresh,
              backgroundColor: Colors.black12,
              focusElevation: 10,
              autofocus: true,
              elevation: 6,
              hoverElevation: 10,
              hoverColor: Colors.red,
              child: Icon(
                FontAwesomeIcons.refresh,
                color: Colors.amber.shade700,
              ),
            ),
    );
  }
}
