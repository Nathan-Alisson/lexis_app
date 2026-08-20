import 'package:flutter/material.dart';

import 'edit_word_screen.dart';

class WordDetailsScreen extends StatelessWidget {
  const WordDetailsScreen({required this.word, super.key});

  final String word;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visualizar palavra'),
        actions: [
          IconButton(
            tooltip: 'Editar palavra',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => EditWordScreen(word: word)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(word, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),
            Text('Significado', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            const Text('Significado ainda não informado.'),
          ],
        ),
      ),
    );
  }
}
