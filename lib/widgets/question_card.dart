import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../models/question.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';

/// Reusable question card widget for displaying questions
class QuestionCard extends StatelessWidget {
  final Question question;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool showActions;

  const QuestionCard({
    super.key,
    required this.question,
    this.onEdit,
    this.onDelete,
    this.onTap,
    this.isSelected = false,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.1)
                : AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.glassBorder,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with metadata chips
              _buildHeader(context),
              const SizedBox(height: 16),

              // Question content
              _buildContent(context),

              // MCQ options if applicable
              if (question.type == QuestionType.mcq && question.options != null)
                _buildOptions(context),

              // Actions
              if (showActions) ...[
                const Divider(height: 24),
                _buildActions(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // Subject chip
        _buildChip(
          label: question.subjectName,
          icon: Icons.book_rounded,
          color: AppColors.info,
        ),
        // Chapter chip
        _buildChip(
          label: 'Ch. ${question.chapterNumber}: ${question.chapterName}',
          icon: Icons.bookmark_rounded,
        ),
        // Question type chip
        _buildChip(
          label:
              AppConstants.questionTypeLabels[question.questionType] ??
              question.questionType,
          icon: _getTypeIcon(question.type),
          color: AppColors.accent,
        ),
        // Difficulty chip
        _buildDifficultyChip(),
        // Marks chip
        _buildChip(
          label: '${question.marks} ${question.marks == 1 ? 'Mark' : 'Marks'}',
          icon: Icons.star_rounded,
          color: AppColors.warning,
        ),
      ],
    );
  }

  Widget _buildChip({required String label, IconData? icon, Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: (color ?? AppColors.textSecondary).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color ?? AppColors.textSecondary),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color ?? AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyChip() {
    Color color;
    switch (question.difficultyLevel) {
      case DifficultyLevel.easy:
        color = AppColors.easy;
        break;
      case DifficultyLevel.medium:
        color = AppColors.medium;
        break;
      case DifficultyLevel.hard:
        color = AppColors.hard;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            AppConstants.difficultyLabels[question.difficulty] ??
                question.difficulty,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: _renderLatexContent(question.content),
    );
  }

  Widget _renderLatexContent(String text) {
    final parts = <Widget>[];
    final segments = text.split('\$');

    for (int i = 0; i < segments.length; i++) {
      if (segments[i].isEmpty) continue;

      if (i % 2 == 1) {
        // LaTeX content
        try {
          parts.add(
            Math.tex(segments[i], textStyle: const TextStyle(fontSize: 15)),
          );
        } catch (e) {
          parts.add(
            Text(
              segments[i],
              style: const TextStyle(fontSize: 15, color: AppColors.error),
            ),
          );
        }
      } else {
        parts.add(Text(segments[i], style: const TextStyle(fontSize: 15)));
      }
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      runSpacing: 6,
      children: parts,
    );
  }

  Widget _buildOptions(BuildContext context) {
    final options = question.options ?? [];

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: options.asMap().entries.map((entry) {
          final optionLabel = String.fromCharCode(65 + entry.key);
          final isCorrect = entry.key == question.correctOptionIndex;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isCorrect
                        ? AppColors.success.withValues(alpha: 0.2)
                        : AppColors.surfaceLight,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCorrect
                          ? AppColors.success
                          : AppColors.glassBorder,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      optionLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isCorrect
                            ? AppColors.success
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: _renderLatexContent(entry.value)),
                if (isCorrect)
                  Icon(Icons.check_circle, color: AppColors.success, size: 18),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (onEdit != null)
          TextButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_rounded, size: 18),
            label: const Text('Edit'),
          ),
        const SizedBox(width: 8),
        if (onDelete != null)
          TextButton.icon(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded, size: 18),
            label: const Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
          ),
      ],
    );
  }

  IconData _getTypeIcon(QuestionType type) {
    switch (type) {
      case QuestionType.mcq:
        return Icons.radio_button_checked_rounded;
      case QuestionType.shortAnswer:
        return Icons.short_text_rounded;
      case QuestionType.longAnswer:
        return Icons.subject_rounded;
      case QuestionType.fillInBlanks:
        return Icons.space_bar_rounded;
    }
  }
}
