import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_diu/widgets/quiz_models.dart';

class QuestionCard extends StatefulWidget {
  const QuestionCard({
    super.key,
    required this.quizQuestion,
    required this.question_index,
    required this.addAnswer,
  });
  final QuizQuestion quizQuestion;
  final int question_index;
  final void Function(int index,bool isSelected) addAnswer;

  @override
  State<QuestionCard> createState() {
    return _QuestionCardState();
  }
}

class _QuestionCardState extends State<QuestionCard> {
  int? selectedAnswerIndex; // State variable to track selected answer

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shadowColor: ThemeData().colorScheme.scrim,
        elevation: 10,
        margin: EdgeInsets.all(10),
        color: ThemeData().colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.quizQuestion.question,
                style: GoogleFonts.roboto(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ...widget.quizQuestion.quizQuestionAnswers
                  .asMap()
                  .entries
                  .map((entry) {
                int answerIndex = entry.key;
                var answer = entry.value;
                // Generate the serial (A., B., C., etc.)
                String serial = String.fromCharCode(65 + answerIndex);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAnswerIndex = answerIndex; // Update selected index
                    });
                    widget.addAnswer(widget.question_index,answer.isCorrect);
                  },
                  child: Container(
                    
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: selectedAnswerIndex == answerIndex
                        ? Colors.blueAccent.shade100 // Highlight selected answer
                        : Colors.white10,
                    ), // Default color
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display the serial
                        Text(
                          "$serial. ",
                          style: GoogleFonts.roboto(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        // Display the answer text
                        Expanded(
                          child: Text(
                            answer.answer,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                            style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}