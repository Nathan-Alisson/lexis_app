import 'package:flutter/material.dart';

import 'word_form.dart';

class EditWordScreen extends StatelessWidget {
  const EditWordScreen({required this.word, super.key});

  final String word;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar palavra')),
      body: WordForm(
        initialWord: word,
        initialMeaning: 'Significado ainda não informado.',
        submitLabel: 'Salvar alterações',
        onSubmit: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Interface pronta para salvar')),
        ),
      ),
    );
  }
}
