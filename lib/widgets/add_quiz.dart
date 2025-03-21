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
    return Container(
      child: Text("Add Quiz"),
    );
  }
}