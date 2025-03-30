
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultScreen extends StatefulWidget{
  const ResultScreen({super.key,required this.data,required this.totalMarks});
  final data;
  final totalMarks;

  @override
  State<ResultScreen> createState() {
    return _ResultScreenState();
  }

}

class _ResultScreenState extends State<ResultScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeData().colorScheme.primaryContainer,
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset("assets/gifs/results.png",width: 300,),
              widget.data==false?Expanded(child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Looks like you don't attept the quiz!",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: GoogleFonts.permanentMarker(fontSize: 25,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20,),
                  Icon(FontAwesomeIcons.faceAngry,color: Colors.red.shade900,size: 200,),
                ],
              ),
              )
              :
              Card(
                margin: EdgeInsets.all(30),
                color: ThemeData().colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Total Marks : ${widget.totalMarks}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.permanentMarker(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,

                      ),
                      ),
                      SizedBox(height: 30,),
                      Text("Number of questions : ${(widget.data["numberOfQuestions"]).toString()}",
                      style: GoogleFonts.permanentMarker(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        
                      ),
                      ),
                      SizedBox(height: 10,),
                      Text("Correct Answers : ${(widget.data["numberOfCorrectAnswers"]).toString()}",
                      style: GoogleFonts.permanentMarker(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        
                      ),
                      ),
                      SizedBox(height: 10,),
                      Text("You got : ${(widget.data["achievedMarks"]).toString()}",
                      style: GoogleFonts.permanentMarker(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        
                      ),
                      ),
                  
                  
                    ],
                  
                  ),
                ),
              ),


              ElevatedButton(onPressed: (){
                Navigator.pop(context);

              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
              ),
              child: Text("Return",style: GoogleFonts.roboto(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),)),
              SizedBox(height: 100,),

            ],
          ),
        
        ),
      )
    );
  }

}