/// Application constants
class AppConstants {
  static const String appName = 'Question Paper Generator';
  static const String institutionName = 'Carbon Gurukulam';

  /// Question type display names
  static const Map<String, String> questionTypeLabels = {
    'mcq': 'Multiple Choice',
    'shortAnswer': 'Short Answer',
    'longAnswer': 'Long Answer',
    'fillInBlanks': 'Fill in Blanks',
  };

  /// Difficulty level display names
  static const Map<String, String> difficultyLabels = {
    'easy': 'Easy',
    'medium': 'Medium',
    'hard': 'Hard',
  };

  /// Default marks by question type
  static const Map<String, int> defaultMarksByType = {
    'mcq': 1,
    'shortAnswer': 2,
    'longAnswer': 5,
    'fillInBlanks': 1,
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
    {'label': 'Sum', 'symbol': r'\sum_{i=1}^{n}'},
    {'label': 'Integral', 'symbol': r'\int_{a}^{b}'},
    {'label': 'Infinity', 'symbol': r'\infty'},
    {'label': 'Plus/Minus', 'symbol': r'\pm'},
    {'label': 'Times', 'symbol': r'\times'},
    {'label': 'Divide', 'symbol': r'\div'},
    {'label': 'Not Equal', 'symbol': r'\neq'},
    {'label': 'Less than or Equal', 'symbol': r'\leq'},
    {'label': 'Greater than or Equal', 'symbol': r'\geq'},
    {'label': 'Arrow Right', 'symbol': r'\rightarrow'},
    {'label': 'Degree', 'symbol': r'^\circ'},
    {'label': 'Percentage', 'symbol': r'\%'},
  ];

  /// Animation durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
}
