import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';

/// LaTeX input field with live preview and symbol toolbar
class LatexInput extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final int minLines;
  final int maxLines;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const LatexInput({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.minLines = 3,
    this.maxLines = 6,
    this.validator,
    this.onChanged,
  });

  @override
  State<LatexInput> createState() => _LatexInputState();
}

class _LatexInputState extends State<LatexInput> {
  bool _showPreview = false;
  bool _showSymbols = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Text(
                  widget.label!,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                // Preview toggle
                TextButton.icon(
                  onPressed: () => setState(() => _showPreview = !_showPreview),
                  icon: Icon(
                    _showPreview ? Icons.visibility_off : Icons.visibility,
                    size: 18,
                  ),
                  label: Text(_showPreview ? 'Hide Preview' : 'Show Preview'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                  ),
                ),
                // Symbols toggle
                TextButton.icon(
                  onPressed: () => setState(() => _showSymbols = !_showSymbols),
                  icon: Icon(
                    Icons.functions,
                    size: 18,
                    color: _showSymbols ? AppColors.primary : null,
                  ),
                  label: Text('Symbols'),
                  style: TextButton.styleFrom(
                    foregroundColor: _showSymbols
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

        // Symbol toolbar
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: _showSymbols
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: _buildSymbolToolbar(),
          secondChild: const SizedBox(height: 0),
        ),

        // Text input
        TextFormField(
          controller: widget.controller,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          validator: widget.validator,
          onChanged: (value) {
            widget.onChanged?.call(value);
            setState(() {});
          },
          decoration: InputDecoration(
            hintText:
                widget.hint ?? 'Enter question content (use \$...\$ for LaTeX)',
            hintStyle: const TextStyle(color: AppColors.textMuted),
          ),
          style: const TextStyle(fontFamily: 'monospace'),
        ),

        // Live preview
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: _showPreview
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: _buildPreview(),
          secondChild: const SizedBox(height: 0),
        ),
      ],
    );
  }

  Widget _buildSymbolToolbar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: AppConstants.latexSymbols.map((symbol) {
          return Tooltip(
            message: symbol['label']!,
            child: InkWell(
              onTap: () => _insertSymbol(symbol['symbol']!),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Text(
                  symbol['label']!,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPreview() {
    final text = widget.controller.text;

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.preview, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                'Preview',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          if (text.isEmpty)
            Text(
              'Enter content to see preview...',
              style: TextStyle(
                color: AppColors.textMuted,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            _renderLatexContent(text),
        ],
      ),
    );
  }

  Widget _renderLatexContent(String text) {
    // Split by $ to find LaTeX parts
    final parts = <Widget>[];
    final segments = text.split('\$');

    for (int i = 0; i < segments.length; i++) {
      if (segments[i].isEmpty) continue;

      if (i % 2 == 1) {
        // LaTeX content (inside $...$)
        try {
          parts.add(
            Math.tex(
              segments[i],
              textStyle: const TextStyle(fontSize: 16),
              mathStyle: MathStyle.display,
            ),
          );
        } catch (e) {
          // Invalid LaTeX, show as error
          parts.add(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                segments[i],
                style: const TextStyle(color: AppColors.error),
              ),
            ),
          );
        }
      } else {
        // Regular text
        parts.add(Text(segments[i], style: const TextStyle(fontSize: 16)));
      }
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4,
      runSpacing: 8,
      children: parts,
    );
  }

  void _insertSymbol(String symbol) {
    final text = widget.controller.text;
    final selection = widget.controller.selection;
    final newText = text.replaceRange(
      selection.start,
      selection.end,
      '\$$symbol\$',
    );
    widget.controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.start + symbol.length + 2,
      ),
    );
    setState(() {});
  }
}
