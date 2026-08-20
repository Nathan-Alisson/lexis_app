import 'package:flutter/material.dart';

import 'new_word_screen.dart';
import 'settings_screen.dart';
import 'word_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _words = ['alcova', 'andar', 'barreira', 'comedido'];
  String _search = '';

  List<String> get _filteredWords {
    final query = _search.trim().toLowerCase();
    if (query.isEmpty) return _words;
    return _words.where((word) => word.contains(query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final words = _filteredWords;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Dicionário'),
        actions: [
          IconButton(
            tooltip: 'Configurações',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Pesquisar',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => _search = value),
              ),
            ),
            Expanded(
              child: words.isEmpty
                  ? const Center(child: Text('Nenhuma palavra encontrada'))
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 88),
                      itemCount: words.length,
                      itemBuilder: (context, index) {
                        final word = words[index];
                        final showLetter = index == 0 ||
                            words[index - 1][0].toUpperCase() !=
                                word[0].toUpperCase();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (showLetter)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                                child: Text(
                                  word[0].toUpperCase(),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            ListTile(
                              title: Text(word),
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => WordDetailsScreen(word: word),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Nova palavra',
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const NewWordScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
