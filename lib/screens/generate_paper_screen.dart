import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/question.dart';
import '../models/subject.dart';
import '../services/storage_service.dart';
import '../services/pdf_service.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/question_card.dart';

/// Screen for generating question papers
class GeneratePaperScreen extends StatefulWidget {
  const GeneratePaperScreen({super.key});

  @override
  State<GeneratePaperScreen> createState() => _GeneratePaperScreenState();
}

class _GeneratePaperScreenState extends State<GeneratePaperScreen> {
  // Paper settings
  final _titleController = TextEditingController(text: 'Unit Test');
  DateTime _examDate = DateTime.now();
  int _duration = 60;

  // Question selection
  Subject? _selectedSubject;
  final Set<int> _selectedChapters = {};
  final Set<String> _selectedQuestionIds = {};

  // Generation mode
  bool _isManualSelection = false;
  int _targetMarks = 50;

  // UI state
  int _currentStep = 0;
  bool _isGenerating = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StorageService>(
      builder: (context, storage, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 32),

              // Stepper-like layout
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Steps sidebar
                  _buildStepsSidebar(),
                  const SizedBox(width: 32),

                  // Main content
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: _buildCurrentStep(storage),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.description_rounded, color: AppColors.accent),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Generate Question Paper',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Text(
              'Create a customized question paper from your question bank',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepsSidebar() {
    final steps = [
      ('Paper Settings', Icons.settings_rounded),
      ('Select Questions', Icons.checklist_rounded),
      ('Preview & Export', Icons.preview_rounded),
    ];

    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          final isActive = index == _currentStep;
          final isCompleted = index < _currentStep;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: InkWell(
              onTap: () {
                if (index < _currentStep || _canProceedToStep(index)) {
                  setState(() => _currentStep = index);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isActive
                        ? AppColors.primary
                        : isCompleted
                        ? AppColors.success.withValues(alpha: 0.5)
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppColors.success
                            : isActive
                            ? AppColors.primary
                            : AppColors.surfaceLight,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 18,
                              )
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: isActive
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        step.$1,
                        style: TextStyle(
                          color: isActive
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCurrentStep(StorageService storage) {
    switch (_currentStep) {
      case 0:
        return _buildPaperSettingsStep(storage);
      case 1:
        return _buildSelectQuestionsStep(storage);
      case 2:
        return _buildPreviewStep(storage);
      default:
        return const SizedBox();
    }
  }

  Widget _buildPaperSettingsStep(StorageService storage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Paper Settings',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 24),

        // Paper title
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Paper Title',
            hintText: 'e.g., Unit Test, Mid-Term Examination',
            prefixIcon: Icon(Icons.title),
          ),
        ),
        const SizedBox(height: 20),

        // Subject selection
        DropdownButtonFormField<Subject>(
          key: ValueKey(_selectedSubject),
          initialValue: _selectedSubject,
          decoration: const InputDecoration(
            labelText: 'Subject',
            prefixIcon: Icon(Icons.book_rounded),
          ),
          items: storage.subjects.map((s) {
            return DropdownMenuItem(value: s, child: Text(s.name));
          }).toList(),
          onChanged: (subject) {
            setState(() {
              _selectedSubject = subject;
              _selectedChapters.clear();
              _selectedQuestionIds.clear();
            });
          },
        ),
        const SizedBox(height: 20),

        // Chapter selection
        if (_selectedSubject != null) ...[
          Text(
            'Select Chapters',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _selectedSubject!.chapters.map((chapter) {
              final isSelected = _selectedChapters.contains(chapter.number);
              return FilterChip(
                label: Text('${chapter.number}. ${chapter.name}'),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedChapters.add(chapter.number);
                    } else {
                      _selectedChapters.remove(chapter.number);
                    }
                    _selectedQuestionIds.clear();
                  });
                },
                selectedColor: AppColors.primary.withValues(alpha: 0.3),
                checkmarkColor: AppColors.primary,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],

        // Exam details row
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Exam Date',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(_formatDate(_examDate)),
                ),
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 150,
              child: TextFormField(
                initialValue: _duration.toString(),
                decoration: const InputDecoration(
                  labelText: 'Duration (mins)',
                  prefixIcon: Icon(Icons.timer),
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => _duration = int.tryParse(v) ?? 60,
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 150,
              child: TextFormField(
                initialValue: _targetMarks.toString(),
                decoration: const InputDecoration(
                  labelText: 'Total Marks',
                  prefixIcon: Icon(Icons.star),
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => _targetMarks = int.tryParse(v) ?? 50,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Selection mode
        Text(
          'Question Selection Mode',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildModeCard(
                title: 'Auto Select',
                subtitle: 'Automatically pick random questions',
                icon: Icons.auto_awesome,
                isSelected: !_isManualSelection,
                onTap: () => setState(() => _isManualSelection = false),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildModeCard(
                title: 'Manual Select',
                subtitle: 'Choose questions yourself',
                icon: Icons.checklist_rounded,
                isSelected: _isManualSelection,
                onTap: () => setState(() => _isManualSelection = true),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Next button
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: _canProceedToStep(1)
                  ? () => setState(() => _currentStep = 1)
                  : null,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next: Select Questions'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surfaceLight.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.glassBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectQuestionsStep(StorageService storage) {
    final availableQuestions = storage
        .getFilteredQuestions(subjectId: _selectedSubject?.id)
        .where(
          (q) =>
              _selectedChapters.isEmpty ||
              _selectedChapters.contains(q.chapterNumber),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select Questions',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            _buildSelectionSummary(),
          ],
        ),
        const SizedBox(height: 24),

        if (availableQuestions.isEmpty)
          _buildNoQuestionsMessage()
        else if (_isManualSelection)
          _buildManualSelection(availableQuestions)
        else
          _buildAutoSelection(availableQuestions, storage),

        const SizedBox(height: 32),

        // Navigation buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton.icon(
              onPressed: () => setState(() => _currentStep = 0),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
            ),
            ElevatedButton.icon(
              onPressed: _selectedQuestionIds.isNotEmpty
                  ? () => setState(() => _currentStep = 2)
                  : null,
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next: Preview'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectionSummary() {
    final totalMarks = _getSelectedMarks();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: totalMarks >= _targetMarks
            ? AppColors.success.withValues(alpha: 0.15)
            : AppColors.warning.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            totalMarks >= _targetMarks
                ? Icons.check_circle
                : Icons.info_outline,
            size: 18,
            color: totalMarks >= _targetMarks
                ? AppColors.success
                : AppColors.warning,
          ),
          const SizedBox(width: 8),
          Text(
            '${_selectedQuestionIds.length} questions • $totalMarks/$_targetMarks marks',
            style: TextStyle(
              color: totalMarks >= _targetMarks
                  ? AppColors.success
                  : AppColors.warning,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoQuestionsMessage() {
    return Center(
      child: Column(
        children: [
          Icon(Icons.warning_rounded, size: 64, color: AppColors.warning),
          const SizedBox(height: 16),
          Text(
            'No questions available',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Add questions to the selected subject/chapters first',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildManualSelection(List<Question> questions) {
    return SizedBox(
      height: 500,
      child: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          final isSelected = _selectedQuestionIds.contains(question.id);

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: QuestionCard(
              question: question,
              isSelected: isSelected,
              showActions: false,
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedQuestionIds.remove(question.id);
                  } else {
                    _selectedQuestionIds.add(question.id);
                  }
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildAutoSelection(List<Question> questions, StorageService storage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.info),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Auto-select will randomly pick questions from ${questions.length} available questions to reach $_targetMarks marks. Click the button below to generate.',
                  style: TextStyle(color: AppColors.info),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: ElevatedButton.icon(
            onPressed: () => _autoSelectQuestions(questions),
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Auto-Select Questions'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ),
        if (_selectedQuestionIds.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'Selected Questions:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ...storage
              .getQuestionsByIds(_selectedQuestionIds.toList())
              .map(
                (q) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: QuestionCard(
                    question: q,
                    isSelected: true,
                    showActions: false,
                    onTap: () =>
                        setState(() => _selectedQuestionIds.remove(q.id)),
                  ),
                ),
              ),
        ],
      ],
    );
  }

  Widget _buildPreviewStep(StorageService storage) {
    final selectedQuestions = storage.getQuestionsByIds(
      _selectedQuestionIds.toList(),
    );
    final totalMarks = selectedQuestions.fold(0, (sum, q) => sum + q.marks);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preview & Export',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 24),

        // Paper summary
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppConstants.institutionName.toUpperCase(),
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(letterSpacing: 2),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _titleController.text,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const Divider(height: 24),
              Wrap(
                spacing: 24,
                runSpacing: 8,
                children: [
                  _buildInfoChip('Subject', _selectedSubject?.name ?? '-'),
                  _buildInfoChip('Date', _formatDate(_examDate)),
                  _buildInfoChip('Duration', '$_duration mins'),
                  _buildInfoChip('Total Marks', '$totalMarks'),
                  _buildInfoChip('Questions', '${selectedQuestions.length}'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Questions preview (collapsed)
        Text('Questions:', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: selectedQuestions.length,
            itemBuilder: (context, index) {
              final q = selectedQuestions[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        q.content.length > 100
                            ? '${q.content.substring(0, 100)}...'
                            : q.content,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${q.marks}m',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 32),

        // Action buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton.icon(
              onPressed: () => setState(() => _currentStep = 1),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
            ),
            ElevatedButton.icon(
              onPressed: _isGenerating
                  ? null
                  : () => _generatePdf(storage, selectedQuestions),
              icon: _isGenerating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.picture_as_pdf),
              label: Text(_isGenerating ? 'Generating...' : 'Generate PDF'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: ', style: TextStyle(color: AppColors.textSecondary)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  bool _canProceedToStep(int step) {
    switch (step) {
      case 1:
        return _selectedSubject != null && _titleController.text.isNotEmpty;
      case 2:
        return _selectedQuestionIds.isNotEmpty;
      default:
        return true;
    }
  }

  int _getSelectedMarks() {
    final storage = Provider.of<StorageService>(context, listen: false);
    return storage
        .getQuestionsByIds(_selectedQuestionIds.toList())
        .fold(0, (sum, q) => sum + q.marks);
  }

  void _autoSelectQuestions(List<Question> questions) {
    _selectedQuestionIds.clear();
    int currentMarks = 0;
    final shuffled = List<Question>.from(questions)..shuffle();

    for (final question in shuffled) {
      if (currentMarks + question.marks <= _targetMarks) {
        _selectedQuestionIds.add(question.id);
        currentMarks += question.marks;
      }
      if (currentMarks >= _targetMarks) break;
    }

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Selected ${_selectedQuestionIds.length} questions ($currentMarks marks)',
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _examDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _examDate = date);
    }
  }

  String _formatDate(DateTime date) {
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

  Future<void> _generatePdf(
    StorageService storage,
    List<Question> questions,
  ) async {
    setState(() => _isGenerating = true);

    try {
      await PdfService.generateAndPreviewPdf(
        context,
        title: _titleController.text,
        subject: _selectedSubject!.name,
        examDate: _examDate,
        duration: _duration,
        totalMarks: questions.fold(0, (sum, q) => sum + q.marks),
        questions: questions,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating PDF: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }
}
