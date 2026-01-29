import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/question.dart';
import '../models/subject.dart';

/// Service for managing local storage using Hive
class StorageService extends ChangeNotifier {
  static const String _questionsBox = 'questions';
  static const String _subjectsBox = 'subjects';

  late Box<Question> _questionBox;
  late Box<Subject> _subjectBox;
  final _uuid = const Uuid();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// Initialize Hive and open boxes
  Future<void> init() async {
    if (_isInitialized) return;

    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(QuestionAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(SubjectAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(ChapterAdapter());
    }

    _questionBox = await Hive.openBox<Question>(_questionsBox);
    _subjectBox = await Hive.openBox<Subject>(_subjectsBox);

    // Add default subjects if empty
    if (_subjectBox.isEmpty) {
      await _addDefaultSubjects();
    }

    _isInitialized = true;
    notifyListeners();
  }

  /// Add default subjects with chapters
  Future<void> _addDefaultSubjects() async {
    final defaultSubjects = [
      Subject(
        id: _uuid.v4(),
        name: 'Mathematics',
        chapters: [
          Chapter(number: 1, name: 'Real Numbers'),
          Chapter(number: 2, name: 'Polynomials'),
          Chapter(number: 3, name: 'Pair of Linear Equations'),
          Chapter(number: 4, name: 'Quadratic Equations'),
          Chapter(number: 5, name: 'Arithmetic Progressions'),
          Chapter(number: 6, name: 'Triangles'),
          Chapter(number: 7, name: 'Coordinate Geometry'),
          Chapter(number: 8, name: 'Trigonometry'),
          Chapter(number: 9, name: 'Circles'),
          Chapter(number: 10, name: 'Statistics'),
        ],
        createdAt: DateTime.now(),
      ),
      Subject(
        id: _uuid.v4(),
        name: 'Physics',
        chapters: [
          Chapter(number: 1, name: 'Physical World'),
          Chapter(number: 2, name: 'Units and Measurements'),
          Chapter(number: 3, name: 'Motion in a Straight Line'),
          Chapter(number: 4, name: 'Motion in a Plane'),
          Chapter(number: 5, name: 'Laws of Motion'),
          Chapter(number: 6, name: 'Work, Energy and Power'),
          Chapter(number: 7, name: 'Gravitation'),
          Chapter(number: 8, name: 'Mechanical Properties'),
        ],
        createdAt: DateTime.now(),
      ),
      Subject(
        id: _uuid.v4(),
        name: 'Chemistry',
        chapters: [
          Chapter(number: 1, name: 'Chemical Reactions'),
          Chapter(number: 2, name: 'Acids, Bases and Salts'),
          Chapter(number: 3, name: 'Metals and Non-metals'),
          Chapter(number: 4, name: 'Carbon and its Compounds'),
          Chapter(number: 5, name: 'Periodic Classification'),
        ],
        createdAt: DateTime.now(),
      ),
      Subject(
        id: _uuid.v4(),
        name: 'Biology',
        chapters: [
          Chapter(number: 1, name: 'Life Processes'),
          Chapter(number: 2, name: 'Control and Coordination'),
          Chapter(number: 3, name: 'Reproduction'),
          Chapter(number: 4, name: 'Heredity and Evolution'),
          Chapter(number: 5, name: 'Environment'),
        ],
        createdAt: DateTime.now(),
      ),
    ];

    for (final subject in defaultSubjects) {
      await _subjectBox.put(subject.id, subject);
    }
  }

  // ==================== Question Operations ====================

  /// Get all questions
  List<Question> get questions => _questionBox.values.toList();

  /// Get questions filtered by criteria
  List<Question> getFilteredQuestions({
    String? subjectId,
    int? chapterNumber,
    String? questionType,
    String? difficulty,
  }) {
    return questions.where((q) {
      if (subjectId != null && q.subjectId != subjectId) return false;
      if (chapterNumber != null && q.chapterNumber != chapterNumber) {
        return false;
      }
      if (questionType != null && q.questionType != questionType) return false;
      if (difficulty != null && q.difficulty != difficulty) return false;
      return true;
    }).toList();
  }

  /// Get questions by IDs
  List<Question> getQuestionsByIds(List<String> ids) {
    return questions.where((q) => ids.contains(q.id)).toList();
  }

  /// Add a new question
  Future<void> addQuestion(Question question) async {
    await _questionBox.put(question.id, question);
    notifyListeners();
  }

  /// Update an existing question
  Future<void> updateQuestion(Question question) async {
    await _questionBox.put(question.id, question);
    notifyListeners();
  }

  /// Delete a question
  Future<void> deleteQuestion(String id) async {
    await _questionBox.delete(id);
    notifyListeners();
  }

  /// Generate a new question ID
  String generateQuestionId() => _uuid.v4();

  // ==================== Subject Operations ====================

  /// Get all subjects
  List<Subject> get subjects => _subjectBox.values.toList();

  /// Get subject by ID
  Subject? getSubjectById(String id) {
    try {
      return subjects.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Add a new subject
  Future<void> addSubject(Subject subject) async {
    await _subjectBox.put(subject.id, subject);
    notifyListeners();
  }

  /// Update a subject
  Future<void> updateSubject(Subject subject) async {
    await _subjectBox.put(subject.id, subject);
    notifyListeners();
  }

  /// Delete a subject
  Future<void> deleteSubject(String id) async {
    await _subjectBox.delete(id);
    notifyListeners();
  }

  /// Add a chapter to a subject
  Future<void> addChapterToSubject(String subjectId, Chapter chapter) async {
    final subject = getSubjectById(subjectId);
    if (subject != null) {
      final updatedChapters = [...subject.chapters, chapter];
      await updateSubject(subject.copyWith(chapters: updatedChapters));
    }
  }

  /// Generate a new subject ID
  String generateSubjectId() => _uuid.v4();

  // ==================== Statistics ====================

  /// Get question count by subject
  Map<String, int> get questionCountBySubject {
    final counts = <String, int>{};
    for (final question in questions) {
      counts[question.subjectName] = (counts[question.subjectName] ?? 0) + 1;
    }
    return counts;
  }

  /// Get total question count
  int get totalQuestions => questions.length;

  /// Get question count by type
  Map<String, int> get questionCountByType {
    final counts = <String, int>{};
    for (final question in questions) {
      counts[question.questionType] = (counts[question.questionType] ?? 0) + 1;
    }
    return counts;
  }
}
