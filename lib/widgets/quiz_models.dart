import 'dart:convert';

// Main Quiz Model
class Quiz {
  final int quizId;
  final Course course;
  final Teacher teacher;
  final Section section;
  final List<QuizQuestion> quizQuestions;
  final String quizName;
  final DateTime startTime;
  final DateTime endTime;

  Quiz({
    required this.quizId,
    required this.course,
    required this.teacher,
    required this.section,
    required this.quizQuestions,
    required this.quizName,
    required this.startTime,
    required this.endTime,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      quizId: json['quiz_id'],
      course: Course.fromJson(json['course']),
      teacher: Teacher.fromJson(json['teacher']),
      section: Section.fromJson(json['section']),
      quizQuestions: (json['quiz_questions'] as List)
          .map((q) => QuizQuestion.fromJson(q))
          .toList(),
      quizName: json['quiz_name'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quiz_id': quizId,
      'course': course.toJson(),
      'teacher': teacher.toJson(),
      'section': section.toJson(),
      'quiz_questions': quizQuestions.map((q) => q.toJson()).toList(),
      'quiz_name': quizName,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
    };
  }
}

// Course Model
class Course {
  final int id;
  final String courseId;
  final String courseName;
  final int department;

  Course({
    required this.id,
    required this.courseId,
    required this.courseName,
    required this.department,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      courseId: json['course_id'],
      courseName: json['course_name'],
      department: json['department'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'course_id': courseId,
        'course_name': courseName,
        'department': department,
      };
}

// Teacher Model
class Teacher {
  final int id;
  final List<Course> courses;
  final List<Section> sections;
  final String teacherId;
  final int user;

  Teacher({
    required this.id,
    required this.courses,
    required this.sections,
    required this.teacherId,
    required this.user,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      courses: (json['course'] as List)
          .map((c) => Course.fromJson(c))
          .toList(),
      sections: (json['section'] as List)
          .map((s) => Section.fromJson(s))
          .toList(),
      teacherId: json['teacher_id'],
      user: json['user'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'course': courses.map((c) => c.toJson()).toList(),
        'section': sections.map((s) => s.toJson()).toList(),
        'teacher_id': teacherId,
        'user': user,
      };
}

// Section Model
class Section {
  final int id;
  final String sectionName;
  final List<int> courses;

  Section({
    required this.id,
    required this.sectionName,
    required this.courses,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'],
      sectionName: json['section_name'],
      courses: List<int>.from(json['course']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'section_name': sectionName,
        'course': courses,
      };
}

// Quiz Question Model
class QuizQuestion {
  final int questionId;
  final String question;
  final int quiz;
  final List<QuizAnswer> quizQuestionAnswers;

  QuizQuestion({
    required this.questionId,
    required this.question,
    required this.quiz,
    required this.quizQuestionAnswers,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      questionId: json['question_id'],
      question: json['question'],
      quiz: json['quiz'],
      quizQuestionAnswers: (json['quiz_question_answers'] as List)
          .map((a) => QuizAnswer.fromJson(a))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'question_id': questionId,
        'question': question,
        'quiz': quiz,
        'quiz_question_answers': quizQuestionAnswers.map((a) => a.toJson()).toList(),
      };
}

// Quiz Answer Model
class QuizAnswer {
  final int answerId;
  final String answer;
  final bool isCorrect;
  final int question;

  QuizAnswer({
    required this.answerId,
    required this.answer,
    required this.isCorrect,
    required this.question,
  });

  factory QuizAnswer.fromJson(Map<String, dynamic> json) {
    return QuizAnswer(
      answerId: json['answer_id'],
      answer: json['answer'],
      isCorrect: json['is_correct'],
      question: json['question'],
    );
  }

  Map<String, dynamic> toJson() => {
        'answer_id': answerId,
        'answer': answer,
        'is_correct': isCorrect,
        'question': question,
      };
}

// Function to Parse JSON List
List<Quiz> parseQuizzes(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Quiz>((json) => Quiz.fromJson(json)).toList();
}
