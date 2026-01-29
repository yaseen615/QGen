import 'package:hive/hive.dart';

part 'question.g.dart';

/// Question types available in the system
enum QuestionType { mcq, shortAnswer, longAnswer, fillInBlanks }

/// Difficulty levels for questions
enum DifficultyLevel { easy, medium, hard }

/// Question model for the question bank
@HiveType(typeId: 0)
class Question extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String content; // LaTeX supported content

  @HiveField(2)
  String subjectId;

  @HiveField(3)
  String subjectName;

  @HiveField(4)
  int chapterNumber;

  @HiveField(5)
  String chapterName;

  @HiveField(6)
  String questionType; // stored as string for Hive

  @HiveField(7)
  String difficulty; // stored as string for Hive

  @HiveField(8)
  int marks;

  @HiveField(9)
  List<String>? options; // For MCQ type

  @HiveField(10)
  int? correctOptionIndex; // For MCQ type

  @HiveField(11)
  String? answer; // For non-MCQ types

  @HiveField(12)
  DateTime createdAt;

  @HiveField(13)
  DateTime updatedAt;

  Question({
    required this.id,
    required this.content,
    required this.subjectId,
    required this.subjectName,
    required this.chapterNumber,
    required this.chapterName,
    required this.questionType,
    required this.difficulty,
    required this.marks,
    this.options,
    this.correctOptionIndex,
    this.answer,
    required this.createdAt,
    required this.updatedAt,
  });

  QuestionType get type => QuestionType.values.firstWhere(
    (e) => e.name == questionType,
    orElse: () => QuestionType.shortAnswer,
  );

  DifficultyLevel get difficultyLevel => DifficultyLevel.values.firstWhere(
    (e) => e.name == difficulty,
    orElse: () => DifficultyLevel.medium,
  );

  Question copyWith({
    String? content,
    String? subjectId,
    String? subjectName,
    int? chapterNumber,
    String? chapterName,
    String? questionType,
    String? difficulty,
    int? marks,
    List<String>? options,
    int? correctOptionIndex,
    String? answer,
  }) {
    return Question(
      id: id,
      content: content ?? this.content,
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      chapterName: chapterName ?? this.chapterName,
      questionType: questionType ?? this.questionType,
      difficulty: difficulty ?? this.difficulty,
      marks: marks ?? this.marks,
      options: options ?? this.options,
      correctOptionIndex: correctOptionIndex ?? this.correctOptionIndex,
      answer: answer ?? this.answer,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'subjectId': subjectId,
      'subjectName': subjectName,
      'chapterNumber': chapterNumber,
      'chapterName': chapterName,
      'questionType': questionType,
      'difficulty': difficulty,
      'marks': marks,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'answer': answer,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      content: json['content'],
      subjectId: json['subjectId'],
      subjectName: json['subjectName'],
      chapterNumber: json['chapterNumber'],
      chapterName: json['chapterName'],
      questionType: json['questionType'],
      difficulty: json['difficulty'],
      marks: json['marks'],
      options: json['options'] != null
          ? List<String>.from(json['options'])
          : null,
      correctOptionIndex: json['correctOptionIndex'],
      answer: json['answer'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
