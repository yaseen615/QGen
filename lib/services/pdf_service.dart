import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/question.dart';
import '../models/paper.dart';

/// Service for generating PDF question papers
class PdfService {
  /// Generate and preview PDF
  static Future<void> generateAndPreviewPdf(
    BuildContext context, {
    required String title,
    required String subject,
    required DateTime examDate,
    required int duration,
    required int totalMarks,
    required List<Question> questions,
    String institutionName = 'Carbon Gurukulam',
  }) async {
    final pdf = await _buildPdf(
      title: title,
      subject: subject,
      examDate: examDate,
      duration: duration,
      totalMarks: totalMarks,
      questions: questions,
      institutionName: institutionName,
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: '${title.replaceAll(' ', '_')}_$subject.pdf',
    );
  }

  /// Generate PDF from created paper
  static Future<void> generateFromPaper(
    BuildContext context, {
    required GeneratedPaper paper,
    required List<Question> questions,
  }) async {
    await generateAndPreviewPdf(
      context,
      title: paper.title,
      subject: paper.subjectName,
      examDate: paper.examDate,
      duration: paper.durationMinutes,
      totalMarks: paper.totalMarks,
      questions: questions,
      institutionName: paper.institutionName,
    );
  }

  /// Build the PDF document
  static Future<pw.Document> _buildPdf({
    required String title,
    required String subject,
    required DateTime examDate,
    required int duration,
    required int totalMarks,
    required List<Question> questions,
    required String institutionName,
  }) async {
    final pdf = pw.Document();

    // Group questions by type
    final mcqQuestions = questions
        .where((q) => q.type == QuestionType.mcq)
        .toList();
    final shortQuestions = questions
        .where((q) => q.type == QuestionType.shortAnswer)
        .toList();
    final longQuestions = questions
        .where((q) => q.type == QuestionType.longAnswer)
        .toList();
    final fillQuestions = questions
        .where((q) => q.type == QuestionType.fillInBlanks)
        .toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        header: (context) => _buildHeader(
          institutionName: institutionName,
          title: title,
          subject: subject,
          examDate: examDate,
          duration: duration,
          totalMarks: totalMarks,
          isFirstPage: context.pageNumber == 1,
        ),
        footer: (context) => _buildFooter(context),
        build: (context) {
          final widgets = <pw.Widget>[];
          int questionNumber = 1;

          // MCQ Section
          if (mcqQuestions.isNotEmpty) {
            widgets.add(
              _buildSectionHeader('Section A - Multiple Choice Questions'),
            );
            widgets.add(pw.SizedBox(height: 8));
            widgets.add(
              pw.Text(
                'Choose the correct option for each question.',
                style: pw.TextStyle(
                  fontStyle: pw.FontStyle.italic,
                  fontSize: 10,
                ),
              ),
            );
            widgets.add(pw.SizedBox(height: 12));

            for (final question in mcqQuestions) {
              widgets.add(_buildMcqQuestion(questionNumber++, question));
              widgets.add(pw.SizedBox(height: 12));
            }
            widgets.add(pw.SizedBox(height: 20));
          }

          // Fill in the Blanks Section
          if (fillQuestions.isNotEmpty) {
            widgets.add(_buildSectionHeader('Section B - Fill in the Blanks'));
            widgets.add(pw.SizedBox(height: 12));

            for (final question in fillQuestions) {
              widgets.add(_buildQuestion(questionNumber++, question));
              widgets.add(pw.SizedBox(height: 12));
            }
            widgets.add(pw.SizedBox(height: 20));
          }

          // Short Answer Section
          if (shortQuestions.isNotEmpty) {
            widgets.add(
              _buildSectionHeader('Section C - Short Answer Questions'),
            );
            widgets.add(pw.SizedBox(height: 12));

            for (final question in shortQuestions) {
              widgets.add(
                _buildQuestion(questionNumber++, question, linesForAnswer: 4),
              );
              widgets.add(pw.SizedBox(height: 16));
            }
            widgets.add(pw.SizedBox(height: 20));
          }

          // Long Answer Section
          if (longQuestions.isNotEmpty) {
            widgets.add(
              _buildSectionHeader('Section D - Long Answer Questions'),
            );
            widgets.add(pw.SizedBox(height: 12));

            for (final question in longQuestions) {
              widgets.add(
                _buildQuestion(questionNumber++, question, linesForAnswer: 10),
              );
              widgets.add(pw.SizedBox(height: 20));
            }
          }

          return widgets;
        },
      ),
    );

    return pdf;
  }

  /// Build paper header
  static pw.Widget _buildHeader({
    required String institutionName,
    required String title,
    required String subject,
    required DateTime examDate,
    required int duration,
    required int totalMarks,
    required bool isFirstPage,
  }) {
    if (!isFirstPage) {
      return pw.Container(
        margin: const pw.EdgeInsets.only(bottom: 10),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              institutionName,
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(subject, style: const pw.TextStyle(fontSize: 10)),
          ],
        ),
      );
    }

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            institutionName.toUpperCase(),
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            title,
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.5)),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                pw.Text(
                  'Subject: $subject',
                  style: const pw.TextStyle(fontSize: 11),
                ),
                pw.Text(
                  'Date: ${_formatDate(examDate)}',
                  style: const pw.TextStyle(fontSize: 11),
                ),
                pw.Text(
                  'Duration: $duration mins',
                  style: const pw.TextStyle(fontSize: 11),
                ),
                pw.Text(
                  'Max Marks: $totalMarks',
                  style: const pw.TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            color: PdfColors.grey200,
            child: pw.Text(
              'General Instructions: Read all questions carefully. Attempt all questions. Write legibly.',
              style: const pw.TextStyle(fontSize: 9),
              textAlign: pw.TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// Build section header
  static pw.Widget _buildSectionHeader(String title) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey300,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  /// Build regular question
  static pw.Widget _buildQuestion(
    int number,
    Question question, {
    int linesForAnswer = 0,
  }) {
    // Parse LaTeX to plain text (simplified - in real app use LaTeX parser)
    final content = _cleanLatex(question.content);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              '$number. ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Expanded(
              child: pw.Text(content, style: const pw.TextStyle(fontSize: 11)),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(width: 0.5),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(3)),
              ),
              child: pw.Text(
                '[${question.marks}]',
                style: const pw.TextStyle(fontSize: 9),
              ),
            ),
          ],
        ),
        if (linesForAnswer > 0) ...[
          pw.SizedBox(height: 8),
          for (int i = 0; i < linesForAnswer; i++)
            pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 16),
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  bottom: pw.BorderSide(width: 0.3, color: PdfColors.grey400),
                ),
              ),
            ),
        ],
      ],
    );
  }

  /// Build MCQ question with options
  static pw.Widget _buildMcqQuestion(int number, Question question) {
    final content = _cleanLatex(question.content);
    final options = question.options ?? [];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              '$number. ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Expanded(
              child: pw.Text(content, style: const pw.TextStyle(fontSize: 11)),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(width: 0.5),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(3)),
              ),
              child: pw.Text(
                '[${question.marks}]',
                style: const pw.TextStyle(fontSize: 9),
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 6),
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 16),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: options.asMap().entries.map((entry) {
              final optionLabel = String.fromCharCode(
                65 + entry.key,
              ); // A, B, C, D
              return pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 2),
                child: pw.Row(
                  children: [
                    pw.Container(
                      width: 18,
                      height: 18,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(width: 0.5),
                        shape: pw.BoxShape.circle,
                      ),
                      child: pw.Center(
                        child: pw.Text(
                          optionLabel,
                          style: const pw.TextStyle(fontSize: 9),
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 8),
                    pw.Text(
                      _cleanLatex(entry.value),
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Build footer
  static pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  /// Clean LaTeX markers for PDF (simplified conversion)
  static String _cleanLatex(String text) {
    // Remove $...$ markers but keep content
    String cleaned = text.replaceAll(RegExp(r'\$'), '');
    // Convert common LaTeX to text
    cleaned = cleaned.replaceAll(r'\frac', '/');
    cleaned = cleaned.replaceAll(r'\sqrt', '√');
    cleaned = cleaned.replaceAll(r'\times', '×');
    cleaned = cleaned.replaceAll(r'\div', '÷');
    cleaned = cleaned.replaceAll(r'\pm', '±');
    cleaned = cleaned.replaceAll(r'\leq', '≤');
    cleaned = cleaned.replaceAll(r'\geq', '≥');
    cleaned = cleaned.replaceAll(r'\neq', '≠');
    cleaned = cleaned.replaceAll(r'\pi', 'π');
    cleaned = cleaned.replaceAll(r'\alpha', 'α');
    cleaned = cleaned.replaceAll(r'\beta', 'β');
    cleaned = cleaned.replaceAll(r'\theta', 'θ');
    cleaned = cleaned.replaceAll(
      RegExp(r'\\[a-zA-Z]+'),
      '',
    ); // Remove remaining commands
    cleaned = cleaned.replaceAll(RegExp(r'[{}]'), ''); // Remove braces
    return cleaned.trim();
  }

  /// Format date for display
  static String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
