import 'package:flutter/material.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Play Pokey's Puzzle")),
      body: const Center(
        child: Text('Puzzle coming soon...'),
      ),
    );
  }
}
