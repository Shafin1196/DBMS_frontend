import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddQuiz extends StatefulWidget {
  const AddQuiz({super.key,required this.userId});
  final int userId;
  @override
  State<AddQuiz> createState() {
    return _AddQuizState();
  }
}
class _AddQuizState extends State<AddQuiz> {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(top: 30,left: 16,right: 16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: "Quiz Title",
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: "Quiz Description",
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: "Quiz Duration",
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: "Quiz Total Marks",
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: "Quiz Pass Marks",
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: "Quiz Start Time",
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: "Quiz End Time",
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: "Quiz Date",
            ),
          ),
          SizedBox(height: 25,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: (){},
                child: Text("Add Quiz"),
              ),
              SizedBox(width: 16,),
              ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}