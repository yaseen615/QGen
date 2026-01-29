import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/question.dart';
import '../services/storage_service.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/question_card.dart';
import 'create_question_screen.dart';

/// Screen for viewing and managing the question bank
class QuestionBankScreen extends StatefulWidget {
  const QuestionBankScreen({super.key});

  @override
  State<QuestionBankScreen> createState() => _QuestionBankScreenState();
}

class _QuestionBankScreenState extends State<QuestionBankScreen> {
  String? _filterSubjectId;
  int? _filterChapter;
  String? _filterType;
  String? _filterDifficulty;
  String _searchQuery = '';

  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StorageService>(
      builder: (context, storage, child) {
        final filteredQuestions = _getFilteredQuestions(storage);

        return Column(
          children: [
            // Header and filters
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  bottom: BorderSide(color: AppColors.glassBorder),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, storage),
                  const SizedBox(height: 20),
                  _buildFilters(storage),
                ],
              ),
            ),

            // Question list
            Expanded(
              child: filteredQuestions.isEmpty
                  ? _buildEmptyState()
                  : _buildQuestionList(filteredQuestions, storage),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, StorageService storage) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.folder_rounded, color: AppColors.info),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Question Bank',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                '${storage.totalQuestions} questions in bank',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),

        // Search
        SizedBox(
          width: 300,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search questions...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilters(StorageService storage) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Subject filter
        SizedBox(
          width: 200,
          child: DropdownButtonFormField<String?>(
            key: ValueKey(_filterSubjectId),
            initialValue: _filterSubjectId,
            decoration: const InputDecoration(
              labelText: 'Subject',
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            items: [
              const DropdownMenuItem(value: null, child: Text('All Subjects')),
              ...storage.subjects.map(
                (s) => DropdownMenuItem(value: s.id, child: Text(s.name)),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _filterSubjectId = value;
                _filterChapter = null;
              });
            },
          ),
        ),

        // Chapter filter
        if (_filterSubjectId != null)
          SizedBox(
            width: 200,
            child: DropdownButtonFormField<int?>(
              key: ValueKey(_filterChapter),
              initialValue: _filterChapter,
              decoration: const InputDecoration(
                labelText: 'Chapter',
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('All Chapters'),
                ),
                ...(storage.getSubjectById(_filterSubjectId!)?.chapters ?? [])
                    .map(
                      (c) => DropdownMenuItem(
                        value: c.number,
                        child: Text('${c.number}. ${c.name}'),
                      ),
                    ),
              ],
              onChanged: (value) {
                setState(() => _filterChapter = value);
              },
            ),
          ),

        // Type filter
        SizedBox(
          width: 180,
          child: DropdownButtonFormField<String?>(
            key: ValueKey(_filterType),
            initialValue: _filterType,
            decoration: const InputDecoration(
              labelText: 'Type',
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            items: [
              const DropdownMenuItem(value: null, child: Text('All Types')),
              ...AppConstants.questionTypeLabels.entries.map(
                (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
              ),
            ],
            onChanged: (value) {
              setState(() => _filterType = value);
            },
          ),
        ),

        // Difficulty filter
        SizedBox(
          width: 150,
          child: DropdownButtonFormField<String?>(
            key: ValueKey(_filterDifficulty),
            initialValue: _filterDifficulty,
            decoration: const InputDecoration(
              labelText: 'Difficulty',
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            items: [
              const DropdownMenuItem(value: null, child: Text('All')),
              ...AppConstants.difficultyLabels.entries.map(
                (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
              ),
            ],
            onChanged: (value) {
              setState(() => _filterDifficulty = value);
            },
          ),
        ),

        // Clear filters button
        if (_hasActiveFilters())
          TextButton.icon(
            onPressed: _clearFilters,
            icon: const Icon(Icons.clear_all),
            label: const Text('Clear Filters'),
          ),
      ],
    );
  }

  Widget _buildQuestionList(List<Question> questions, StorageService storage) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: QuestionCard(
            question: question,
            onEdit: () => _editQuestion(context, question, storage),
            onDelete: () => _deleteQuestion(context, question, storage),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 80,
            color: AppColors.textMuted.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 24),
          Text(
            _hasActiveFilters()
                ? 'No questions match filters'
                : 'No questions yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _hasActiveFilters()
                ? 'Try adjusting your filter criteria'
                : 'Start by adding questions using the Create Question screen',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          if (_hasActiveFilters()) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _clearFilters,
              icon: const Icon(Icons.clear_all),
              label: const Text('Clear All Filters'),
            ),
          ],
        ],
      ),
    );
  }

  List<Question> _getFilteredQuestions(StorageService storage) {
    var questions = storage.getFilteredQuestions(
      subjectId: _filterSubjectId,
      chapterNumber: _filterChapter,
      questionType: _filterType,
      difficulty: _filterDifficulty,
    );

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      questions = questions.where((q) {
        return q.content.toLowerCase().contains(query) ||
            q.subjectName.toLowerCase().contains(query) ||
            q.chapterName.toLowerCase().contains(query);
      }).toList();
    }

    // Sort by creation date (newest first)
    questions.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return questions;
  }

  bool _hasActiveFilters() {
    return _filterSubjectId != null ||
        _filterChapter != null ||
        _filterType != null ||
        _filterDifficulty != null ||
        _searchQuery.isNotEmpty;
  }

  void _clearFilters() {
    setState(() {
      _filterSubjectId = null;
      _filterChapter = null;
      _filterType = null;
      _filterDifficulty = null;
      _searchQuery = '';
      _searchController.clear();
    });
  }

  void _editQuestion(
    BuildContext context,
    Question question,
    StorageService storage,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          width: 900,
          constraints: const BoxConstraints(maxHeight: 800),
          decoration: BoxDecoration(
            color: AppColors.background, // Using background for dialog
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CreateQuestionScreen(question: question),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteQuestion(
    BuildContext context,
    Question question,
    StorageService storage,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Question'),
        content: const Text(
          'Are you sure you want to delete this question? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await storage.deleteQuestion(question.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Question deleted')));
    }
  }
}
