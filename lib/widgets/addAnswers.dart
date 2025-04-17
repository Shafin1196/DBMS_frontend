import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  String _isCorrect = "False";
  void showError(message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'Alert!',
                style: GoogleFonts.permanentMarker(
                    color: Colors.red,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              content: Text(
                message,
                style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            ));
  }

  bool isValid() {
    if (_answer.text.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
  final bool hasTrueAnswer = widget.question.quizQuestionAnswers.any((answer) => answer.isCorrect);
  // Set the isTrue list based on the condition
  final List<String> isTrue = hasTrueAnswer ? ["False"] : ["True", "False"];
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
          SizedBox(
            height: 10,
          ),
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
              labelText: "Correct?",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    print(isValid());
                    if (isValid()) {
                      final createAnswers = CreateAnswer(
                          answer: _answer.text,
                          isCorrect: _isCorrect == "True" ? true : false,
                          question: widget.question.questionId);
                      await ApiService.createAnswer(createAnswers);
                      final quizAnswer = QuizAnswer(
                          answerId: await ApiService.getAnswerId(),
                          answer: _answer.text,
                          isCorrect: _isCorrect == "True" ? true : false,
                          question: widget.question.questionId);
                      widget.addAnswer(quizAnswer, widget.index);
                      Navigator.pop(context);
                    } else {
                      showError("All fields required!");
                    }
                  },
                  child: Text("Add")),
              SizedBox(
                width: 30,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"))
            ],
          ),
        ],
      ),
    );
  }
}
