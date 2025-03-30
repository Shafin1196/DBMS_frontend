

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_diu/widgets/ApiService/api.dart';
import 'package:quiz_diu/widgets/quiz_models.dart';

class Addquestions extends StatefulWidget {
  const Addquestions({super.key,required this.addQuestion,required this.quiz});
  final void Function(QuizQuestion) addQuestion;
  final Quiz quiz;
  @override
  State<Addquestions> createState() {
    return _AddquestionsState();
  }
}
class _AddquestionsState extends State<Addquestions> {
  final enteredQuestion=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            child: TextFormField(
              controller: enteredQuestion,
              decoration: InputDecoration(
                labelText: "Question",
                hintText: "Enter Question",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () async{
                List<QuizAnswer> answers=[];
                final QuizQuestion question=QuizQuestion(questionId: await ApiService.getQuestionId(), question: enteredQuestion.text, quiz: widget.quiz.quizId, quizQuestionAnswers: answers );
                widget.addQuestion(question);
                final createQuestion =CreateQuestion(question: enteredQuestion.text, quiz: widget.quiz.quizId);
                ApiService.createQuestion(createQuestion);
                Navigator.of(context).pop();
              }, 
              child: Text("Add",)),
              SizedBox(width: 20,),
              ElevatedButton(onPressed: (){
                Navigator.pop(context);
              }, 
              child: Text("Cancel",)),
            ],
          ),
        ],
      ),
    );
  }
}