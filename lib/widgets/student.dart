import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_diu/widgets/constrants.dart';
import 'package:quiz_diu/widgets/models.dart';
import 'package:quiz_diu/widgets/quiz_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_diu/widgets/auth.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key, required this.user, required this.all_quiz});
  final LoginResponse user;
  final List<Quiz> all_quiz;
  @override
  State<StudentHomeScreen> createState() => _StudentState();
}

class _StudentState extends State<StudentHomeScreen> {
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
                  child: Icon(Icons.person, size: 25, color: const Color.fromARGB(255, 10, 10, 8)),
                ),
                SizedBox(width: 5),
                Text((widget.user.user.name),
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
            SizedBox(height: 20),
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
                            icon: Icon(FontAwesomeIcons.arrowRight,size: 30,color: Colors.amberAccent.shade700,),
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
    );
  }
}