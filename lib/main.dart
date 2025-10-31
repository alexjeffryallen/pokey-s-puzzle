import 'package:flutter/material.dart';
import 'screens/create_screen.dart';
import 'screens/play_screen.dart';

void main() {
  runApp(const PokeysPuzzleApp());
}

class PokeysPuzzleApp extends StatelessWidget {
  const PokeysPuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pokey's Puzzle",
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.orangeAccent,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokey's Puzzle 🧩"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateScreen()),
              ),
              child: const Text('Create Puzzle'),
            ),
            const SizedBox(height: 20),
            FilledButton.tonal(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PlayScreen()),
              ),
              child: const Text('Play Puzzle'),
            ),
          ],
        ),
      ),
    );
  }
}
