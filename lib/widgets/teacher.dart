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

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({super.key,required this.user,required this.all_quiz,required this.teacher});
  final LoginResponse user;
  final Teacher teacher;
  final List<Quiz> all_quiz;
  
  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  void _addQuiz(Quiz quiz){
    setState(() {
      widget.all_quiz.add(quiz);
    });
    
  }
  void _overLay(){
    showModalBottomSheet(
        isScrollControlled: true,
      context: context,
       builder: (ctx)=>AddQuiz(userId: widget.user.user.id,addQuiz: _addQuiz,teacher: widget.teacher,all_quiz: widget.all_quiz,),
    );
  }
  @override
void initState() {
  super.initState();
  
  widget.all_quiz.sort((a, b) => b.startTime.compareTo(a.startTime));
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.yellow,
                  child: Icon(FontAwesomeIcons.userPen,size: 25,color: const Color.fromARGB(255, 10, 10, 8),),
                ),
                SizedBox(width: 5,),
                Expanded(
                  flex: 6,
                  child: Text(widget.user.user.name,
                    style: GoogleFonts.permanentMarker(fontSize: 25,fontWeight: FontWeight.bold),
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
                                color: Colors.black12,
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
                              Expanded(child: Text(widget.all_quiz[index].course.courseName,style: cardTextStyle,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              )),
                              Spacer(),
                              Expanded(child: Text(widget.all_quiz[index].section.sectionName,style: cardTextStyle,)),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: (){
                              Navigator.push(context,
                              MaterialPageRoute(builder: (context) => EditQuiz(quiz: widget.all_quiz[index],))
                              );
                              
                            },
                            icon: Icon(FontAwesomeIcons.edit,size: 30,color: Colors.amberAccent.shade700,),
                          ),
                        ),
                      ).animate()
    .fadeIn(duration: 500.ms, curve: Curves.easeIn) // Fade-in animation
    .slide(begin: Offset(1, 0), end: Offset(0, 0), duration: 500.ms); 
                      
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
          onPressed: (){
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

