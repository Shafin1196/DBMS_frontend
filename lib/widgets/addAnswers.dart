import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_diu/widgets/ApiService/api.dart';
import 'package:quiz_diu/widgets/quiz_models.dart';

class AddAnswers extends StatefulWidget {
  const AddAnswers(
      {super.key,
      required this.question,
      required this.addAnswer,
      required this.index});
  final QuizQuestion question;
  final int index;
  final void Function(QuizAnswer answer, int index) addAnswer;
  @override
  State<AddAnswers> createState() {
    return _AddAnswersState();
  }
}

class _AddAnswersState extends State<AddAnswers> {
  final _answer = TextEditingController();
  String _isCorrect="False";
  @override
  Widget build(BuildContext context) {
    final List<String> isTrue=["True","False"];
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _answer,
            decoration: InputDecoration(
              labelText: "Answers",
              hintText: "Enter Answers",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10,),
          DropdownButtonFormField<String>(
            value: _isCorrect,
            items: isTrue.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _isCorrect = value!;
              });
            },
            decoration: const InputDecoration(
              labelText: "Course",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20,),
           Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: ()async{
                  print("1");
                  final quizAnswer=QuizAnswer(answerId: await ApiService.getAnswerId(), answer: _answer.text, isCorrect: _isCorrect=="True"?true:false, question: widget.question.questionId);
                  print("2");
                  widget.addAnswer(quizAnswer,widget.index);

                  final createAnswers=CreateAnswer(answer: _answer.text, isCorrect: _isCorrect=="True"?true:false, question: widget.question.questionId);
                  ApiService.createAnswer(createAnswers);
                  Navigator.pop(context);

                }, child: Text("Add")),
                SizedBox(width: 30,),
                ElevatedButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text("Cancel"))

              ],
          ),
        ],
      ),
    );
  }
}
