/// Generated Paper model for storing paper configurations
class GeneratedPaper {
  final String id;
  final String title;
  final String institutionName;
  final String subjectName;
  final DateTime examDate;
  final int durationMinutes;
  final int totalMarks;
  final List<String> questionIds;
  final List<PaperSection> sections;
  final DateTime createdAt;

  GeneratedPaper({
    required this.id,
    required this.title,
    this.institutionName = 'Carbon Gurukulam',
    required this.subjectName,
    required this.examDate,
    required this.durationMinutes,
    required this.totalMarks,
    required this.questionIds,
    required this.sections,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'institutionName': institutionName,
      'subjectName': subjectName,
      'examDate': examDate.toIso8601String(),
      'durationMinutes': durationMinutes,
      'totalMarks': totalMarks,
      'questionIds': questionIds,
      'sections': sections.map((s) => s.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory GeneratedPaper.fromJson(Map<String, dynamic> json) {
    return GeneratedPaper(
      id: json['id'],
      title: json['title'],
      institutionName: json['institutionName'] ?? 'Carbon Gurukulam',
      subjectName: json['subjectName'],
      examDate: DateTime.parse(json['examDate']),
      durationMinutes: json['durationMinutes'],
      totalMarks: json['totalMarks'],
      questionIds: List<String>.from(json['questionIds']),
      sections: (json['sections'] as List)
          .map((s) => PaperSection.fromJson(s))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

/// Section within a paper (e.g., Section A - MCQs)
class PaperSection {
  final String name;
  final String? instructions;
  final List<String> questionIds;

  PaperSection({
    required this.name,
    this.instructions,
    required this.questionIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'instructions': instructions,
      'questionIds': questionIds,
    };
  }

  factory PaperSection.fromJson(Map<String, dynamic> json) {
    return PaperSection(
      name: json['name'],
      instructions: json['instructions'],
      questionIds: List<String>.from(json['questionIds']),
    );
  }
}
