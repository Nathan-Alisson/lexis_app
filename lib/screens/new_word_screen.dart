import 'package:flutter/material.dart';

import 'word_form.dart';

class NewWordScreen extends StatelessWidget {
  const NewWordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova palavra')),
      body: WordForm(
        submitLabel: 'Adicionar',
        onSubmit: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Interface pronta para salvar')),
        ),
      ),
    );
  }
}
