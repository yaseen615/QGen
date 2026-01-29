import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/subject.dart';
import '../services/storage_service.dart';
import '../utils/app_theme.dart';

/// Screen for managing subjects and chapters
class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<StorageService>(
      builder: (context, storage, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, storage),
              const SizedBox(height: 32),
              _buildSubjectsList(storage),
            ],
          ),
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
            color: AppColors.success.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.school_rounded, color: AppColors.success),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Subjects & Chapters',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Text(
                '${storage.subjects.length} subjects configured',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _showAddSubjectDialog(context, storage),
          icon: const Icon(Icons.add),
          label: const Text('Add Subject'),
        ),
      ],
    );
  }

  Widget _buildSubjectsList(StorageService storage) {
    return Column(
      children: storage.subjects.map((subject) {
        final questionCount = storage.questionCountBySubject[subject.name] ?? 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        subject.name.substring(0, 1),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          '${subject.chapters.length} chapters • $questionCount questions',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    tooltip: 'Add Chapter',
                    onPressed: () =>
                        _showAddChapterDialog(context, storage, subject),
                  ),
                ],
              ),
              if (subject.chapters.isNotEmpty) ...[
                const Divider(height: 24),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: subject.chapters.map((chapter) {
                    return Chip(
                      avatar: CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.2,
                        ),
                        child: Text(
                          '${chapter.number}',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      label: Text(chapter.name),
                      backgroundColor: AppColors.surfaceLight,
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  void _showAddSubjectDialog(BuildContext context, StorageService storage) {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Subject'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Subject Name',
            hintText: 'e.g., Physics, Chemistry',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isNotEmpty) {
                await storage.addSubject(
                  Subject(
                    id: storage.generateSubjectId(),
                    name: nameController.text.trim(),
                    chapters: [],
                    createdAt: DateTime.now(),
                  ),
                );
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddChapterDialog(
    BuildContext context,
    StorageService storage,
    Subject subject,
  ) {
    final numberController = TextEditingController(
      text: (subject.chapters.length + 1).toString(),
    );
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Chapter to ${subject.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: numberController,
              decoration: const InputDecoration(labelText: 'Chapter Number'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Chapter Name',
                hintText: 'e.g., Introduction to Motion',
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final number = int.tryParse(numberController.text);
              if (number != null && nameController.text.trim().isNotEmpty) {
                await storage.addChapterToSubject(
                  subject.id,
                  Chapter(number: number, name: nameController.text.trim()),
                );
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
