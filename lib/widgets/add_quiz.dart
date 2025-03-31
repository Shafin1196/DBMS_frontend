import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_diu/widgets/ApiService/api.dart';
import 'package:quiz_diu/widgets/quiz_models.dart';

class AddQuiz extends StatefulWidget {
  const AddQuiz({super.key,required this.userId,required this.addQuiz,required this.teacher,required this.all_quiz});
  final int userId;
  final void Function(Quiz) addQuiz;
  final List<Quiz> all_quiz;
  final Teacher teacher;
  @override
  State<AddQuiz> createState() {
    return _AddQuizState();
  }
}
class _AddQuizState extends State<AddQuiz> {
  final _quizName = TextEditingController();
  final _totalMarks = TextEditingController();
  final _startTime = TextEditingController();
  final _endTime = TextEditingController();
  String? _selectedSection;
  String? _selectedCourse;
  Future<void> _selectDateTime(BuildContext context, TextEditingController controller) async {
    // Select Date
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Select Time
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
            controller.text = fullDateTime.toString(); // You can format this as needed
      }
    }
  }
  void showError(String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Alert!',
        style: GoogleFonts.permanentMarker(color: Colors.red,fontSize: 35,fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        ),
        content: Text(message,
        style: GoogleFonts.roboto(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

  bool isValid() {
    if (_quizName.text.isEmpty ||
        _selectedCourse == null ||
        _selectedSection == null ||
        _totalMarks.text.isEmpty ||
        _startTime.text.isEmpty ||
        _endTime.text.isEmpty) {
      return false;
    }
    return true;
  }
  @override
  Widget build(BuildContext context) {
    final List<String> sections = widget.teacher.sections
      .map((section) => section.sectionName)
      .toSet()
      .toList();
    final List<String> courses = widget.teacher.courses
      .map((course) => course.courseName)
      .toSet()
      .toList();
    
    return Padding(padding: EdgeInsets.only(top: 20,left: 16,right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _quizName,
            decoration: InputDecoration(
              labelText: "Quiz Name",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 16,),
         DropdownButtonFormField<String>(
            value: _selectedSection,
            items: sections
                .map((section) => DropdownMenuItem(
                      value: section,
                      child: Text(section),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedSection = value;
              });
            },
            decoration: const InputDecoration(
              labelText: "Section",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),

          // Course Dropdown
          DropdownButtonFormField<String>(
            value: _selectedCourse,
            items: courses
                .map((course) => DropdownMenuItem(
                      value: course,
                      child: Text(course),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedCourse = value;
              });
            },
            decoration: const InputDecoration(
              labelText: "Course",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _totalMarks,
            decoration: InputDecoration(
              labelText: "Total Marks",
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16,),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _startTime,
                  decoration: InputDecoration(
                    labelText: "Start Time",
                    icon: Icon(FontAwesomeIcons.calendarAlt),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.datetime,
                readOnly: true,
                onTap: () => _selectDateTime(context, _startTime),
                ),
              ),
              SizedBox(width: 16,),
              Expanded(
                child: TextFormField(
                  controller: _endTime,
                  decoration: InputDecoration(
                    labelText: "End Time",
                    icon: Icon(FontAwesomeIcons.calendarAlt),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.datetime,
                readOnly: true,
                onTap: () => _selectDateTime(context, _endTime),
                ),
              ),
            ],
          ),
          SizedBox(height: 25,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  print(isValid());
                  if(isValid()){
                  final newQuiz = Quiz(
                    quizId: await ApiService.getQuizId(),
                    quizName: _quizName.text,
                    section: widget.teacher.sections.firstWhere((section) => section.sectionName == _selectedSection),
                    course: widget.teacher.courses.firstWhere((course) => course.courseName == _selectedCourse),
                    startTime: DateTime.parse(_startTime.text),
                    endTime: DateTime.parse(_endTime.text),
                    teacher: widget.teacher,
                    quizQuestions: [],
                    quiz_marks: int.parse(_totalMarks.text)
                  );
                  final createQuiz=CreateQuiz(course: newQuiz.course.id,section: newQuiz.section.id,teacher: newQuiz.teacher.id,quizName: newQuiz.quizName,startTime: newQuiz.startTime.toIso8601String(),endTime: newQuiz.endTime.toIso8601String(),totalMarks: int.parse(_totalMarks.text));
                  ApiService.createQuiz(createQuiz);
                  widget.addQuiz(newQuiz);
                  Navigator.of(context).pop();
                  }
                  else{
                    showError("All fields are required!");
                  }
                },
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