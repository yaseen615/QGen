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

  /// Add default subjects with chapters for NEET/JEE/+1/+2
  Future<void> _addDefaultSubjects() async {
    final defaultSubjects = [
      // Physics - Class 11 & 12 Combined (NEET & JEE)
      Subject(
        id: _uuid.v4(),
        name: 'Physics',
        description: 'Class 11 & 12 Physics for NEET/JEE',
        chapters: [
          // Class 11 Chapters
          Chapter(number: 1, name: 'Physical World'),
          Chapter(number: 2, name: 'Units and Measurements'),
          Chapter(number: 3, name: 'Motion in a Straight Line'),
          Chapter(number: 4, name: 'Motion in a Plane'),
          Chapter(number: 5, name: 'Laws of Motion'),
          Chapter(number: 6, name: 'Work, Energy and Power'),
          Chapter(number: 7, name: 'System of Particles & Rotational Motion'),
          Chapter(number: 8, name: 'Gravitation'),
          Chapter(number: 9, name: 'Mechanical Properties of Solids'),
          Chapter(number: 10, name: 'Mechanical Properties of Fluids'),
          Chapter(number: 11, name: 'Thermal Properties of Matter'),
          Chapter(number: 12, name: 'Thermodynamics'),
          Chapter(number: 13, name: 'Kinetic Theory'),
          Chapter(number: 14, name: 'Oscillations'),
          Chapter(number: 15, name: 'Waves'),
          // Class 12 Chapters
          Chapter(number: 16, name: 'Electric Charges and Fields'),
          Chapter(number: 17, name: 'Electrostatic Potential and Capacitance'),
          Chapter(number: 18, name: 'Current Electricity'),
          Chapter(number: 19, name: 'Moving Charges and Magnetism'),
          Chapter(number: 20, name: 'Magnetism and Matter'),
          Chapter(number: 21, name: 'Electromagnetic Induction'),
          Chapter(number: 22, name: 'Alternating Current'),
          Chapter(number: 23, name: 'Electromagnetic Waves'),
          Chapter(number: 24, name: 'Ray Optics and Optical Instruments'),
          Chapter(number: 25, name: 'Wave Optics'),
          Chapter(number: 26, name: 'Dual Nature of Radiation and Matter'),
          Chapter(number: 27, name: 'Atoms'),
          Chapter(number: 28, name: 'Nuclei'),
          Chapter(number: 29, name: 'Semiconductor Electronics'),
        ],
        createdAt: DateTime.now(),
      ),

      // Chemistry - Class 11 & 12 Combined (NEET & JEE)
      Subject(
        id: _uuid.v4(),
        name: 'Chemistry',
        description: 'Class 11 & 12 Chemistry for NEET/JEE',
        chapters: [
          // Class 11 Chapters
          Chapter(number: 1, name: 'Some Basic Concepts of Chemistry'),
          Chapter(number: 2, name: 'Structure of Atom'),
          Chapter(number: 3, name: 'Classification of Elements'),
          Chapter(number: 4, name: 'Chemical Bonding and Molecular Structure'),
          Chapter(number: 5, name: 'States of Matter'),
          Chapter(number: 6, name: 'Thermodynamics'),
          Chapter(number: 7, name: 'Equilibrium'),
          Chapter(number: 8, name: 'Redox Reactions'),
          Chapter(number: 9, name: 'Hydrogen'),
          Chapter(number: 10, name: 's-Block Elements'),
          Chapter(number: 11, name: 'p-Block Elements (Group 13 & 14)'),
          Chapter(number: 12, name: 'Organic Chemistry - Basic Principles'),
          Chapter(number: 13, name: 'Hydrocarbons'),
          Chapter(number: 14, name: 'Environmental Chemistry'),
          // Class 12 Chapters
          Chapter(number: 15, name: 'Solid State'),
          Chapter(number: 16, name: 'Solutions'),
          Chapter(number: 17, name: 'Electrochemistry'),
          Chapter(number: 18, name: 'Chemical Kinetics'),
          Chapter(number: 19, name: 'Surface Chemistry'),
          Chapter(number: 20, name: 'p-Block Elements (Group 15-18)'),
          Chapter(number: 21, name: 'd and f Block Elements'),
          Chapter(number: 22, name: 'Coordination Compounds'),
          Chapter(number: 23, name: 'Haloalkanes and Haloarenes'),
          Chapter(number: 24, name: 'Alcohols, Phenols and Ethers'),
          Chapter(number: 25, name: 'Aldehydes, Ketones and Carboxylic Acids'),
          Chapter(number: 26, name: 'Amines'),
          Chapter(number: 27, name: 'Biomolecules'),
          Chapter(number: 28, name: 'Polymers'),
          Chapter(number: 29, name: 'Chemistry in Everyday Life'),
        ],
        createdAt: DateTime.now(),
      ),

      // Biology - Class 11 & 12 Combined (NEET)
      Subject(
        id: _uuid.v4(),
        name: 'Biology',
        description: 'Class 11 & 12 Biology for NEET',
        chapters: [
          // Class 11 Chapters - Botany & Zoology
          Chapter(number: 1, name: 'The Living World'),
          Chapter(number: 2, name: 'Biological Classification'),
          Chapter(number: 3, name: 'Plant Kingdom'),
          Chapter(number: 4, name: 'Animal Kingdom'),
          Chapter(number: 5, name: 'Morphology of Flowering Plants'),
          Chapter(number: 6, name: 'Anatomy of Flowering Plants'),
          Chapter(number: 7, name: 'Structural Organisation in Animals'),
          Chapter(number: 8, name: 'Cell: The Unit of Life'),
          Chapter(number: 9, name: 'Biomolecules'),
          Chapter(number: 10, name: 'Cell Cycle and Cell Division'),
          Chapter(number: 11, name: 'Transport in Plants'),
          Chapter(number: 12, name: 'Mineral Nutrition'),
          Chapter(number: 13, name: 'Photosynthesis in Higher Plants'),
          Chapter(number: 14, name: 'Respiration in Plants'),
          Chapter(number: 15, name: 'Plant Growth and Development'),
          Chapter(number: 16, name: 'Digestion and Absorption'),
          Chapter(number: 17, name: 'Breathing and Exchange of Gases'),
          Chapter(number: 18, name: 'Body Fluids and Circulation'),
          Chapter(number: 19, name: 'Excretory Products and Elimination'),
          Chapter(number: 20, name: 'Locomotion and Movement'),
          Chapter(number: 21, name: 'Neural Control and Coordination'),
          Chapter(number: 22, name: 'Chemical Coordination and Integration'),
          // Class 12 Chapters
          Chapter(number: 23, name: 'Reproduction in Organisms'),
          Chapter(number: 24, name: 'Sexual Reproduction in Flowering Plants'),
          Chapter(number: 25, name: 'Human Reproduction'),
          Chapter(number: 26, name: 'Reproductive Health'),
          Chapter(number: 27, name: 'Principles of Inheritance and Variation'),
          Chapter(number: 28, name: 'Molecular Basis of Inheritance'),
          Chapter(number: 29, name: 'Evolution'),
          Chapter(number: 30, name: 'Human Health and Disease'),
          Chapter(
            number: 31,
            name: 'Strategies for Enhancement in Food Production',
          ),
          Chapter(number: 32, name: 'Microbes in Human Welfare'),
          Chapter(number: 33, name: 'Biotechnology: Principles and Processes'),
          Chapter(number: 34, name: 'Biotechnology and its Applications'),
          Chapter(number: 35, name: 'Organisms and Populations'),
          Chapter(number: 36, name: 'Ecosystem'),
          Chapter(number: 37, name: 'Biodiversity and Conservation'),
          Chapter(number: 38, name: 'Environmental Issues'),
        ],
        createdAt: DateTime.now(),
      ),

      // Mathematics - Class 11 & 12 Combined (JEE)
      Subject(
        id: _uuid.v4(),
        name: 'Mathematics',
        description: 'Class 11 & 12 Mathematics for JEE',
        chapters: [
          // Class 11 Chapters
          Chapter(number: 1, name: 'Sets'),
          Chapter(number: 2, name: 'Relations and Functions'),
          Chapter(number: 3, name: 'Trigonometric Functions'),
          Chapter(number: 4, name: 'Complex Numbers and Quadratic Equations'),
          Chapter(number: 5, name: 'Linear Inequalities'),
          Chapter(number: 6, name: 'Permutations and Combinations'),
          Chapter(number: 7, name: 'Binomial Theorem'),
          Chapter(number: 8, name: 'Sequences and Series'),
          Chapter(number: 9, name: 'Straight Lines'),
          Chapter(number: 10, name: 'Conic Sections'),
          Chapter(number: 11, name: 'Introduction to 3D Geometry'),
          Chapter(number: 12, name: 'Limits and Derivatives'),
          Chapter(number: 13, name: 'Statistics'),
          Chapter(number: 14, name: 'Probability'),
          // Class 12 Chapters
          Chapter(number: 15, name: 'Relations and Functions II'),
          Chapter(number: 16, name: 'Inverse Trigonometric Functions'),
          Chapter(number: 17, name: 'Matrices'),
          Chapter(number: 18, name: 'Determinants'),
          Chapter(number: 19, name: 'Continuity and Differentiability'),
          Chapter(number: 20, name: 'Applications of Derivatives'),
          Chapter(number: 21, name: 'Integrals'),
          Chapter(number: 22, name: 'Applications of Integrals'),
          Chapter(number: 23, name: 'Differential Equations'),
          Chapter(number: 24, name: 'Vector Algebra'),
          Chapter(number: 25, name: 'Three Dimensional Geometry'),
          Chapter(number: 26, name: 'Linear Programming'),
          Chapter(number: 27, name: 'Probability II'),
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
