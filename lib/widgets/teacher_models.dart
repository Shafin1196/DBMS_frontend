class Teacher {
  final int id;
  final List<Course> course;
  final List<Section> section;
  final String teacherId;
  final int user;

  Teacher({
    required this.id,
    required this.course,
    required this.section,
    required this.teacherId,
    required this.user,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      course: (json['course'] as List)
          .map((courseJson) => Course.fromJson(courseJson))
          .toList(),
      section: (json['section'] as List)
          .map((sectionJson) => Section.fromJson(sectionJson))
          .toList(),
      teacherId: json['teacher_id'],
      user: json['user'],
    );
  }
}

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
}

class Section {
  final int id;
  final String sectionName;
  final List<int> course;

  Section({
    required this.id,
    required this.sectionName,
    required this.course,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'],
      sectionName: json['section_name'],
      course: List<int>.from(json['course']),
    );
  }
}