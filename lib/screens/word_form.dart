import 'package:flutter/material.dart';

class WordForm extends StatelessWidget {
  const WordForm({
    required this.submitLabel,
    required this.onSubmit,
    this.initialWord = '',
    this.initialMeaning = '',
    super.key,
  });

  final String submitLabel;
  final VoidCallback onSubmit;
  final String initialWord;
  final String initialMeaning;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextFormField(
          initialValue: initialWord,
          decoration: const InputDecoration(
            labelText: 'Palavra',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: initialMeaning,
          decoration: const InputDecoration(
            labelText: 'Significado',
            alignLabelWithHint: true,
            border: OutlineInputBorder(),
          ),
          maxLines: 5,
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: onSubmit,
          icon: const Icon(Icons.check),
          label: Text(submitLabel),
        ),
      ],
    );
  }
}
