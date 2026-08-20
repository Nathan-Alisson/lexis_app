import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const LexisApp());
}

class LexisApp extends StatelessWidget {
  const LexisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meu Dicionário',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
