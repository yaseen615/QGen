/// Application constants for NEET/JEE Question Bank
class AppConstants {
  static const String appName = 'QGen - NEET/JEE Question Bank';
  static const String institutionName = 'QGen';

  /// Exam types
  static const List<String> examTypes = [
    'NEET',
    'JEE Main',
    'JEE Advanced',
    '+1',
    '+2',
  ];

  /// Question type display names
  static const Map<String, String> questionTypeLabels = {
    'mcq': 'Multiple Choice (MCQ)',
    'shortAnswer': 'Short Answer',
    'longAnswer': 'Long Answer',
    'fillInBlanks': 'Fill in Blanks',
    'numerical': 'Numerical Value',
    'assertionReasoning': 'Assertion-Reasoning',
  };

  /// Difficulty level display names
  static const Map<String, String> difficultyLabels = {
    'easy': 'Easy',
    'medium': 'Medium',
    'hard': 'Hard',
  };

  /// Default marks by question type (NEET/JEE pattern)
  static const Map<String, int> defaultMarksByType = {
    'mcq': 4,
    'shortAnswer': 2,
    'longAnswer': 5,
    'fillInBlanks': 1,
    'numerical': 4,
    'assertionReasoning': 4,
  };

  /// Negative marking (NEET/JEE pattern)
  static const Map<String, int> negativeMarksByType = {
    'mcq': -1,
    'numerical': 0,
    'assertionReasoning': -1,
  };

  /// Common LaTeX symbols for quick insertion
  static const List<Map<String, String>> latexSymbols = [
    {'label': 'Fraction', 'symbol': r'\frac{a}{b}'},
    {'label': 'Square Root', 'symbol': r'\sqrt{x}'},
    {'label': 'Power', 'symbol': r'x^{n}'},
    {'label': 'Subscript', 'symbol': r'x_{i}'},
    {'label': 'Pi', 'symbol': r'\pi'},
    {'label': 'Theta', 'symbol': r'\theta'},
    {'label': 'Alpha', 'symbol': r'\alpha'},
    {'label': 'Beta', 'symbol': r'\beta'},
    {'label': 'Gamma', 'symbol': r'\gamma'},
    {'label': 'Delta', 'symbol': r'\Delta'},
    {'label': 'Lambda', 'symbol': r'\lambda'},
    {'label': 'Omega', 'symbol': r'\omega'},
    {'label': 'Sum', 'symbol': r'\sum_{i=1}^{n}'},
    {'label': 'Integral', 'symbol': r'\int_{a}^{b}'},
    {'label': 'Limit', 'symbol': r'\lim_{x \to 0}'},
    {'label': 'Infinity', 'symbol': r'\infty'},
    {'label': 'Plus/Minus', 'symbol': r'\pm'},
    {'label': 'Times', 'symbol': r'\times'},
    {'label': 'Divide', 'symbol': r'\div'},
    {'label': 'Not Equal', 'symbol': r'\neq'},
    {'label': 'Less than or Equal', 'symbol': r'\leq'},
    {'label': 'Greater than or Equal', 'symbol': r'\geq'},
    {'label': 'Arrow Right', 'symbol': r'\rightarrow'},
    {'label': 'Equilibrium', 'symbol': r'\rightleftharpoons'},
    {'label': 'Degree', 'symbol': r'^\circ'},
    {'label': 'Percentage', 'symbol': r'\%'},
    {'label': 'Vector', 'symbol': r'\vec{A}'},
    {'label': 'Hat', 'symbol': r'\hat{i}'},
  ];

  /// Animation durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
}
