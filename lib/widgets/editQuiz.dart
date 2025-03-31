import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_diu/widgets/addAnswers.dart';
import 'package:quiz_diu/widgets/addQuestions.dart';
import 'package:quiz_diu/widgets/quiz_models.dart';

class EditQuiz extends StatefulWidget {
  const EditQuiz({super.key, required this.quiz});
  final Quiz quiz;

  @override
  State<EditQuiz> createState() {
    return _EditQuizState();
  }
}

class _EditQuizState extends State<EditQuiz> {

  void addAnswer(QuizAnswer answers,int index) {
    setState(() {
      widget.quiz.quizQuestions[index].quizQuestionAnswers.add(answers);
    });

  }
  void addQuestion(QuizQuestion question){
    setState(() {
      widget.quiz.quizQuestions.add(question);
    });
  }
  void _answerOverlay(QuizQuestion question,int index){
    showModalBottomSheet(
        isScrollControlled: true,
      context: context,
       builder: (ctx)=>AddAnswers(addAnswer: addAnswer,question: question,index: index,),
    );
  }
  void _questionOverlay(){
    showModalBottomSheet(
        isScrollControlled: true,
      context: context,
       builder: (ctx)=>Addquestions(addQuestion: addQuestion,quiz: widget.quiz,),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: ThemeData().colorScheme.primaryContainer,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: Colors.yellow,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(FontAwesomeIcons.arrowLeft,
                            color: const Color.fromARGB(255, 10, 10, 8),
                            size: 25)),
                  ),
                  SizedBox(width: 60),
                  Icon(FontAwesomeIcons.edit,
                      size: 25, color: const Color.fromARGB(255, 10, 10, 8)),
                  SizedBox(width: 5),
                  Expanded(
                    flex: 4,
                    child: Text(
                      widget.quiz.quizName,
                      style: GoogleFonts.permanentMarker(
                          fontSize: 25, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: widget.quiz.quizQuestions.isEmpty
                      ? Center(
                          child: Text(
                            "No Questions Added Yet!",
                            style: GoogleFonts.permanentMarker(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        )
                      : ListView.builder(
                          itemCount: widget.quiz.quizQuestions.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.grey.shade400,
                                  child: Text(
                                    (index + 1).toString(),
                                    style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Card(
                                    shadowColor: ThemeData().colorScheme.scrim,
                                    elevation: 10,
                                    margin: EdgeInsets.all(10),
                                    color: ThemeData().colorScheme.primaryContainer,
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            widget.quiz.quizQuestions[index].question,
                                            style: GoogleFonts.roboto(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 10),
                                          ...widget.quiz.quizQuestions[index]
                                              .quizQuestionAnswers
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            int answerIndex = entry.key; // Get the index of the answer
                                            var answer =entry.value; // Get the answer object
                                            // Generate the serial (A., B., C., etc.)
                                            String serial =String.fromCharCode(65 + answerIndex);
                                            return Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // Display the serial
                                                Text(
                                                  "$serial. ",
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                // Display the answer text
                                                Expanded(
                                                  flex:10,
                                                  child: Text(
                                                    answer.answer,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 4,
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                Spacer(),
                                                // Display the correct/incorrect icon
                                                Icon(
                                                  answer.isCorrect
                                                      ? FontAwesomeIcons.checkCircle
                                                      : FontAwesomeIcons.timesCircle,
                                                  color: answer.isCorrect
                                                      ? Colors.green
                                                      : Colors.red,
                                                  size: 25,
                                                ),
                                                
                                              ],
                                            );
                                          }),
                                          SizedBox(height: 10),
                                          ElevatedButton(onPressed: (){
                                            _answerOverlay(widget.quiz.quizQuestions[index], index);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.yellow,
                                            
                                         ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                  
                                            children: [
                                              Icon(FontAwesomeIcons.add),
                                              Text("Add Answer"),
                                            ],
                                          ),
                                          ),
                                        ],
                                      
                                      ),
                                    ),
                                    
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _questionOverlay,
      backgroundColor: Colors.black12,
      focusElevation: 10,
      autofocus: true,
      elevation: 6,
      hoverElevation: 10,
      hoverColor: Colors.red,
        child: Icon(
          FontAwesomeIcons.plus,
          color: Colors.amberAccent.shade700,
          size: 30,
        ),
      ),
    );
  }
}
