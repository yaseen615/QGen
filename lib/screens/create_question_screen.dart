import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/question.dart';
import '../models/subject.dart';
import '../services/storage_service.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/latex_input.dart';

/// Screen for creating new questions
class CreateQuestionScreen extends StatefulWidget {
  final Question? question;

  const CreateQuestionScreen({super.key, this.question});

  @override
  State<CreateQuestionScreen> createState() => _CreateQuestionScreenState();
}

class _CreateQuestionScreenState extends State<CreateQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final _optionControllers = List.generate(4, (_) => TextEditingController());
  final _answerController = TextEditingController();

  Subject? _selectedSubject;
  Chapter? _selectedChapter;
  String _questionType = 'mcq';
  String _difficulty = 'medium';
  int _marks = 1;
  int _correctOptionIndex = 0;

  bool _isSubmitting = false;
  bool _isInitialized = false;

  @override
  void dispose() {
    _contentController.dispose();
    for (final c in _optionControllers) {
      c.dispose();
    }
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StorageService>(
      builder: (context, storage, child) {
        if (widget.question != null && !_isInitialized) {
          _initializeForm(storage);
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 32),

                // Main form card
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subject and Chapter selection
                      _buildSubjectChapterSection(storage),
                      const SizedBox(height: 32),

                      // Question content with LaTeX
                      _buildQuestionContentSection(),
                      const SizedBox(height: 32),

                      // Question type, difficulty, marks
                      _buildMetadataSection(),
                      const SizedBox(height: 32),

                      // Options/Answer section
                      _buildAnswerSection(),
                      const SizedBox(height: 32),

                      // Submit button
                      _buildSubmitSection(storage),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.add_circle_outline_rounded,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              widget.question != null ? 'Edit Question' : 'Create New Question',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          widget.question != null
              ? 'Edit this question'
              : 'Add a new question to your question bank with LaTeX support',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildSubjectChapterSection(StorageService storage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subject & Chapter',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<Subject>(
                key: ValueKey(_selectedSubject),
                initialValue: _selectedSubject,
                decoration: const InputDecoration(
                  labelText: 'Select Subject',
                  prefixIcon: Icon(Icons.book_rounded),
                ),
                items: storage.subjects.map((subject) {
                  return DropdownMenuItem(
                    value: subject,
                    child: Text(subject.name),
                  );
                }).toList(),
                onChanged: (subject) {
                  setState(() {
                    _selectedSubject = subject;
                    _selectedChapter = null;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a subject' : null,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: DropdownButtonFormField<Chapter>(
                key: ValueKey(_selectedChapter),
                initialValue: _selectedChapter,
                decoration: const InputDecoration(
                  labelText: 'Select Chapter',
                  prefixIcon: Icon(Icons.bookmark_rounded),
                ),
                items:
                    _selectedSubject?.chapters.map((chapter) {
                      return DropdownMenuItem(
                        value: chapter,
                        child: Text('${chapter.number}. ${chapter.name}'),
                      );
                    }).toList() ??
                    [],
                onChanged: (chapter) {
                  setState(() {
                    _selectedChapter = chapter;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a chapter' : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuestionContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question Content',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        LatexInput(
          controller: _contentController,
          hint:
              'Enter your question here. Use \$...\$ for LaTeX equations.\nExample: Find the value of \$x\$ if \$x^2 + 5x + 6 = 0\$',
          minLines: 4,
          maxLines: 8,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter the question content';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildMetadataSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question Details',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            // Question Type
            SizedBox(
              width: 250,
              child: DropdownButtonFormField<String>(
                key: ValueKey(_questionType),
                initialValue: _questionType,
                decoration: const InputDecoration(
                  labelText: 'Question Type',
                  prefixIcon: Icon(Icons.quiz_rounded),
                ),
                items: AppConstants.questionTypeLabels.entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _questionType = value ?? 'mcq';
                    _marks =
                        AppConstants.defaultMarksByType[_questionType] ?? 1;
                  });
                },
              ),
            ),

            // Difficulty
            SizedBox(
              width: 200,
              child: DropdownButtonFormField<String>(
                key: ValueKey(_difficulty),
                initialValue: _difficulty,
                decoration: const InputDecoration(
                  labelText: 'Difficulty',
                  prefixIcon: Icon(Icons.speed_rounded),
                ),
                items: AppConstants.difficultyLabels.entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(entry.key),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(entry.value),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _difficulty = value ?? 'medium';
                  });
                },
              ),
            ),

            // Marks
            SizedBox(
              width: 150,
              child: TextFormField(
                initialValue: _marks.toString(),
                decoration: const InputDecoration(
                  labelText: 'Marks',
                  prefixIcon: Icon(Icons.star_rounded),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _marks = int.tryParse(value) ?? 1;
                },
                validator: (value) {
                  final marks = int.tryParse(value ?? '');
                  if (marks == null || marks < 1) {
                    return 'Invalid marks';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnswerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _questionType == 'mcq' ? 'Options' : 'Answer (Optional)',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),

        if (_questionType == 'mcq')
          _buildMcqOptions()
        else
          TextFormField(
            controller: _answerController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Answer/Solution',
              hintText: 'Enter the answer or solution (optional)',
            ),
          ),
      ],
    );
  }

  Widget _buildMcqOptions() {
    return RadioGroup<int>(
      groupValue: _correctOptionIndex,
      onChanged: (val) {
        if (val != null) {
          setState(() => _correctOptionIndex = val);
        }
      },
      child: Column(
        children: List.generate(4, (index) {
          final optionLabel = String.fromCharCode(65 + index);
          final isSelected = index == _correctOptionIndex;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                // Radio for correct answer
                Radio<int>(value: index, activeColor: AppColors.success),

                // Option label
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.success.withValues(alpha: 0.2)
                        : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.success
                          : AppColors.glassBorder,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      optionLabel,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? AppColors.success
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Option input
                Expanded(
                  child: TextFormField(
                    controller: _optionControllers[index],
                    decoration: InputDecoration(
                      hintText: 'Option $optionLabel',
                      suffixIcon: isSelected
                          ? const Icon(
                              Icons.check_circle,
                              color: AppColors.success,
                            )
                          : null,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSubmitSection(StorageService storage) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              if (widget.question != null) {
                Navigator.of(context).pop();
              } else {
                _clearForm();
              }
            },
            icon: Icon(
              widget.question != null ? Icons.close : Icons.clear_rounded,
            ),
            label: Text(widget.question != null ? 'Cancel' : 'Clear Form'),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: _isSubmitting ? null : () => _submitQuestion(storage),
            icon: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add_circle_rounded),
            label: Text(
              _isSubmitting
                  ? (widget.question != null ? 'Saving...' : 'Adding...')
                  : (widget.question != null
                        ? 'Save Changes'
                        : 'Add to Question Bank'),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return AppColors.easy;
      case 'medium':
        return AppColors.medium;
      case 'hard':
        return AppColors.hard;
      default:
        return AppColors.textSecondary;
    }
  }

  void _clearForm() {
    _contentController.clear();
    for (final c in _optionControllers) {
      c.clear();
    }
    _answerController.clear();
    setState(() {
      _selectedSubject = null;
      _selectedChapter = null;
      _questionType = 'mcq';
      _difficulty = 'medium';
      _marks = 1;
      _correctOptionIndex = 0;
    });
  }

  void _initializeForm(StorageService storage) {
    final q = widget.question!;
    _contentController.text = q.content;
    _questionType = q.questionType;
    _difficulty = q.difficulty;
    _marks = q.marks;

    try {
      _selectedSubject = storage.subjects.firstWhere(
        (s) => s.id == q.subjectId,
      );
      _selectedChapter = _selectedSubject?.chapters.firstWhere(
        (c) => c.number == q.chapterNumber,
      );
    } catch (_) {
      // Handle missing subject/chapter gracefully
    }

    if (q.questionType == 'mcq' && q.options != null) {
      for (int i = 0; i < 4; i++) {
        if (i < q.options!.length) {
          _optionControllers[i].text = q.options![i];
        }
      }
      _correctOptionIndex = q.correctOptionIndex ?? 0;
    } else {
      _answerController.text = q.answer ?? '';
    }

    _isInitialized = true;
  }

  Future<void> _submitQuestion(StorageService storage) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final question = Question(
        id: widget.question?.id ?? storage.generateQuestionId(),
        content: _contentController.text.trim(),
        subjectId: _selectedSubject!.id,
        subjectName: _selectedSubject!.name,
        chapterNumber: _selectedChapter!.number,
        chapterName: _selectedChapter!.name,
        questionType: _questionType,
        difficulty: _difficulty,
        marks: _marks,
        options: _questionType == 'mcq'
            ? _optionControllers.map((c) => c.text.trim()).toList()
            : null,
        correctOptionIndex: _questionType == 'mcq' ? _correctOptionIndex : null,
        answer: _questionType != 'mcq' ? _answerController.text.trim() : null,
        createdAt: widget.question?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.question != null) {
        await storage.updateQuestion(question);
      } else {
        await storage.addQuestion(question);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.success),
                const SizedBox(width: 12),
                Text(
                  widget.question != null
                      ? 'Question updated successfully!'
                      : 'Question added to ${_selectedSubject!.name} bank!',
                ),
              ],
            ),
            backgroundColor: AppColors.surface,
            behavior: SnackBarBehavior.floating,
          ),
        );
        if (widget.question != null) {
          Navigator.of(context).pop();
        } else {
          _clearForm();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding question: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
