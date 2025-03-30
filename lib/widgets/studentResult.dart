import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, required this.data, required this.totalMarks});
  final data;
  final totalMarks;

  @override
  State<ResultScreen> createState() {
    return _ResultScreenState();
  }
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    var percentageOfMark = 0.0;
    Widget icon = Icon(
      FontAwesomeIcons.faceAngry,
      color: Colors.red.shade900,
      size: 200,
    )
        .animate(
            onPlay: (controller) => controller.repeat()) // Repeat animation
        .scale(duration: 2000.ms, curve: Curves.easeInOut);
    if (widget.data != false) {
      percentageOfMark =
          (widget.data["achievedMarks"] / widget.totalMarks) * 100;
      if (percentageOfMark >= 80) {
        icon = Icon(
          FontAwesomeIcons.faceSurprise,
          color: Colors.blueGrey,
          size: 100,
        )
            .animate(
                onPlay: (controller) => controller.repeat()) // Repeat animation
            .shake(duration: 500.ms, hz: 4, curve: Curves.easeInOut);
      } else if (percentageOfMark >= 50) {
        icon = Icon(
          FontAwesomeIcons.faceFrown,
          color: Colors.red.shade100,
          size: 100,
        )
            .animate(
                onPlay: (controller) => controller.repeat()) // Repeat animation
            .fadeIn(duration: 500.ms, curve: Curves.easeInOut);
      } else {
        icon = Icon(
          FontAwesomeIcons.faceFlushed,
          color: Colors.red.shade900,
          size: 100,
        )
            .animate(
                onPlay: (controller) => controller.repeat()) // Repeat animation
            .rotate(
                duration: 1.seconds,
                curve: Curves.easeInOut); // Add rotate animation
      }
    }
    return Scaffold(
        backgroundColor: ThemeData().colorScheme.primaryContainer,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/gifs/results.png",
                      width: 300,
                    ) // Slide right to left
                    ,
                    widget.data == false
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Looks like you did not attept the quiz!",
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: GoogleFonts.permanentMarker(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              icon,
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              icon,
                              Card(
                                margin: EdgeInsets.all(30),
                                color: ThemeData().colorScheme.primaryContainer,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Total Marks : ${widget.totalMarks}",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.bebasNeue(
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Text(
                                        "Number of questions : ${(widget.data["numberOfQuestions"]).toString()}",
                                        style: GoogleFonts.bebasNeue(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Correct Answers : ${(widget.data["numberOfCorrectAnswers"]).toString()}",
                                        style: GoogleFonts.bebasNeue(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "You got : ${(widget.data["achievedMarks"]).toString()}",
                                        style: GoogleFonts.bebasNeue(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                        ),
                        child: Text(
                          "Return",
                          style: GoogleFonts.roboto(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
