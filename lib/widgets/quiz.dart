import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_diu/widgets/ApiService/api.dart';
import 'package:quiz_diu/widgets/constrants.dart';
import 'package:quiz_diu/widgets/quiz_models.dart';
import 'package:quiz_diu/widgets/showQuestions.dart';
import 'package:quiz_diu/widgets/timer.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.quiz,required this.user_id});
  final Quiz quiz;
  final user_id;
  @override
  State<QuizScreen> createState() {
    return _QuizScreenState();
  }
}

class _QuizScreenState extends State<QuizScreen> {
  late Timer _timer;
  Map<int,bool>selectedAnswers={};
  

  @override
  void initState() {
    super.initState();
    for(int i =0;i<widget.quiz.quizQuestions.length;i++)
    {
      selectedAnswers[i]=false;
    }

    _startEndTimeChecker();
  }

  void addAnswer(int index,bool isSelected){
    setState(() {
      selectedAnswers[index]=isSelected;
    });
  }
  

  void _startEndTimeChecker() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (widget.quiz.endTime.isBefore(DateTime.now())) {
        _timer.cancel(); // Stop the timer
        _submit();
        Navigator.pop(context); // Close the quiz page
      }
    });
  }

  void _submit(){
    if(widget.quiz.quiz_marks !=null)
    {
    var correctAnswer=0;
    selectedAnswers.forEach((key,value){
      if(value){
        correctAnswer++;
      }

    });
    final totalQuestions=selectedAnswers.length;
    final achievedMarks=(widget.quiz.quiz_marks!/totalQuestions)*correctAnswer;
    final Result result=Result(quiz: widget.quiz.quizId, student: widget.user_id, numberOfQuestions: totalQuestions, numberOfCorrectAnswers: correctAnswer, achievedMarks: achievedMarks);
    ApiService.createResult(result);
    }

    
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
                SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  backgroundColor: Colors.yellow,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        FontAwesomeIcons.arrowLeft,
                        color: Colors.black,
                      )),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Text(
                    widget.quiz.quizName,
                    style: GoogleFonts.permanentMarker(
                        fontSize: 30, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Spacer(),
                TimeRemainingPage(
                  endTime: widget.quiz.endTime,
                  onText: TimerOnTopTextStyle,
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView.builder(
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
                                    fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
                              ),
                            ),
                            QuestionCard(quizQuestion: widget.quiz.quizQuestions[index], question_index: index,addAnswer: addAnswer,),
                            
                          ]);
                    }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        _submit();
        Navigator.pop(context);
      },
      backgroundColor: Colors.black12,
      focusElevation: 10,
      autofocus: true,
      elevation: 6,
      hoverElevation: 10,
      hoverColor: Colors.red,
      child: Text("Submit",style: GoogleFonts.roboto(color: Colors.amber.shade700,fontWeight: FontWeight.bold),),
      ),
      floatingActionButtonLocation:FloatingActionButtonLocation.centerDocked,
    );
  }
}
