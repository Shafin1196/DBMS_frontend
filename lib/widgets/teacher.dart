import 'package:flutter/material.dart';
import 'package:quiz_diu/widgets/add_quiz.dart';
import 'package:quiz_diu/widgets/constrants.dart';
import 'package:quiz_diu/widgets/quiz_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_diu/widgets/auth.dart';
import 'package:quiz_diu/widgets/models.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

List<DQuiz> dummy_quiz = [
  DQuiz(id: 1, quizName: "dbms", course_name: "DataBaseManagement ", section_name: "64_C", start_time:  DateTime.now(), end_time: DateTime.now().add(Duration(hours: 1))),
  DQuiz(id: 2, quizName: "dbms2", course_name: "DataBaseManagement", section_name: "64_C", start_time:  DateTime.now(), end_time: DateTime.now().add(Duration(hours: 1))),
  DQuiz(id: 3, quizName: "dbms3", course_name: "DataBaseManagement", section_name: "64_C", start_time:  DateTime.now(), end_time: DateTime.now().add(Duration(hours: 1))),
  DQuiz(id: 4, quizName: "dbms4", course_name: "DataBaseManagement", section_name: "64_C", start_time:  DateTime.now(), end_time: DateTime.now().add(Duration(hours: 1))),
  DQuiz(id: 5, quizName: "dbms5", course_name: "DataBaseManagement", section_name: "64_C", start_time:  DateTime.now(), end_time: DateTime.now().add(Duration(hours: 1))),
  DQuiz(id: 6, quizName: "dbms6", course_name: "DataBaseManagement", section_name: "64_C", start_time:  DateTime.now(), end_time: DateTime.now().add(Duration(hours: 1))),
  DQuiz(id: 7, quizName: "dbms7", course_name: "DataBaseManagement", section_name: "64_C", start_time:  DateTime.now(), end_time: DateTime.now().add(Duration(hours: 1))),
  DQuiz(id: 8, quizName: "dbms8", course_name: "DataBaseManagement", section_name: "64_C", start_time:  DateTime.now(), end_time: DateTime.now().add(Duration(hours: 1))),
  DQuiz(id: 9, quizName: "dbms9", course_name: "DataBaseManagement", section_name: "64_C", start_time:  DateTime.now(), end_time: DateTime.now().add(Duration(hours: 1))),
  DQuiz(id: 10, quizName: "dbms10", course_name: "DataBaseManagement", section_name: "64_C", start_time:  DateTime.now(), end_time: DateTime.now().add(Duration(hours: 1))),
  DQuiz(id: 11, quizName: "dbms11", course_name: "DataBaseManagement", section_name: "64_C", start_time:  DateTime.now(), end_time: DateTime.now().add(Duration(hours: 1))),
  DQuiz(id: 12, quizName: "dbms12", course_name: "DataBaseManagement", section_name: "64_C", start_time:  DateTime.now(), end_time: DateTime.now().add(Duration(hours: 1))),
];
class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({super.key,required this.user,required this.all_quiz});
  final LoginResponse user;
  final List<Quiz> all_quiz;
  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {

  void _overLay(){
    showModalBottomSheet(
        isScrollControlled: true,
      context: context,
       builder: (ctx)=>AddQuiz(userId: widget.user.user.id,),
    );
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
                  child: Icon(FontAwesomeIcons.userPen,size: 25,color: const Color.fromARGB(255, 10, 10, 8),),
                ),
                SizedBox(width: 5,),
                Text(widget.user.user.name,
                  style: GoogleFonts.permanentMarker(fontSize: 25,fontWeight: FontWeight.bold),
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
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Auth(message: "log out successfully!",)));
                  },
                  icon: Icon(FontAwesomeIcons.signOutAlt,size: 25,color: const Color.fromARGB(255, 10, 10, 8),),  
                ),
                ),
                SizedBox(width: 10),
              ],
            ),
            Expanded(
              child: Container(
                  margin: EdgeInsets.only(top: 20 ),
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    ),
                    color: Colors.white,
                  ),
                  child: widget.all_quiz.isEmpty ? Center(
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FontAwesomeIcons.solidMeh,size: 100,color: Colors.amberAccent.shade700,),
                        Text("No Quiz Found",style: GoogleFonts.roboto(fontSize: 20,fontWeight: FontWeight.bold),),
                        SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Click ",style: GoogleFonts.roboto(fontSize: 20,fontWeight: FontWeight.bold),),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: ThemeData().colorScheme.scrim,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Icon(Icons.add,size: 30,color: Colors.amberAccent.shade700,),
                            ),
                            Text(" to add Quiz",style: GoogleFonts.roboto(fontSize: 20,fontWeight: FontWeight.bold),),
                          ],
                        )
                      ],
                    ),
                  ):
                  ListView.builder(
                    itemCount: widget.all_quiz.length,
                    itemBuilder: (context,index){
                      return Card(
                        borderOnForeground: false,
                        elevation: 10,
                        margin: EdgeInsets.all(10),
                        shadowColor: Colors.yellow,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          title: Row( 
              
                            children: [
                              Expanded(child: Text(widget.all_quiz[index].quizName,style: GoogleFonts.roboto(fontSize: 20,fontWeight: FontWeight.bold),)),
                            ],

                          ),
                          subtitle: Row(
                            children: [
                              Expanded(child: Text(widget.all_quiz[index].course.courseName,style: cardTextStyle,)),
                              Spacer(),
                              Expanded(child: Text(widget.all_quiz[index].section.sectionName,style: cardTextStyle,)),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: (){
                              
                            },
                            icon: Icon(FontAwesomeIcons.edit,size: 30,color: Colors.amberAccent.shade700,),
                          ),
                        ),
                      );
                      
                    },
                  ),
                ), 
              ),
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _overLay();
        },
        elevation: 10,
        autofocus: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        focusColor: Colors.amberAccent,

        backgroundColor: ThemeData().colorScheme.scrim,
          child: Icon(
          Icons.add,
          color: Colors.amberAccent.shade700,
          size: 40,
          ),

      ),
    );
  }
}

