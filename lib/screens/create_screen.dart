import 'dart:math';
import 'package:flutter/material.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  int gridSize = 5;
  List<List<String>> grid = [];
  final _wordsController = TextEditingController();

  // Placement state
  List<String> words = [];
  int currentWordIndex = -1;
  int currentLetterIndex = 0;
  List<List<bool>> selectedCells = [];
  bool finalized = false;

  @override
  void initState() {
    super.initState();
    _resetGrid();
  }

  void _resetGrid() {
    grid = List.generate(gridSize, (_) => List.generate(gridSize, (_) => ''));
    selectedCells =
        List.generate(gridSize, (_) => List.generate(gridSize, (_) => false));
    words = [];
    currentWordIndex = -1;
    currentLetterIndex = 0;
    finalized = false;
    setState(() {});
  }

  void _startPlacement() {
    final inputWords = _wordsController.text
        .split(',')
        .map((w) => w.trim().toUpperCase())
        .where((w) => w.isNotEmpty)
        .toList();

    if (inputWords.isEmpty) return;

    words = inputWords;
    currentWordIndex = 0;
    currentLetterIndex = 0;
    grid = List.generate(gridSize, (_) => List.generate(gridSize, (_) => ''));
    selectedCells =
        List.generate(gridSize, (_) => List.generate(gridSize, (_) => false));
    finalized = false;
    setState(() {});
  }

  void _onCellTap(int row, int col) {
    if (finalized || currentWordIndex == -1) return;
    final currentWord = words[currentWordIndex];
    final letter = currentWord[currentLetterIndex];

    // must be adjacent to previous letter (if not the first)
    if (currentLetterIndex > 0) {
      bool adjacent = false;
      for (int r = -1; r <= 1; r++) {
        for (int c = -1; c <= 1; c++) {
          final pr = selectedCells.indexWhere((rowList) => rowList.contains(true));
          // not robust adjacency check yet, just simple
        }
      }
    }

    // Skip if already occupied
    if (grid[row][col].isNotEmpty) return;

    // If it's the first letter or adjacent, place it
    grid[row][col] = letter;
    selectedCells[row][col] = true;
    currentLetterIndex++;

    // If finished the word
    if (currentLetterIndex >= currentWord.length) {
      currentWordIndex++;
      currentLetterIndex = 0;
      if (currentWordIndex >= words.length) {
        // done placing all words
        _finalizePuzzle();
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Now place: ${words[currentWordIndex]}")),
      );
    }

    setState(() {});
  }

  void _finalizePuzzle() {
    final random = Random();
    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (grid[r][c].isEmpty) {
          grid[r][c] = String.fromCharCode(65 + random.nextInt(26));
        }
      }
    }
    finalized = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentWord =
    (currentWordIndex >= 0 && currentWordIndex < words.length)
        ? words[currentWordIndex]
        : '';

    return Scaffold(
      appBar: AppBar(title: const Text("Create a Pokey Puzzle")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Grid size:'),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: gridSize,
                  items: [4, 5, 6, 7, 8]
                      .map((n) => DropdownMenuItem(value: n, child: Text('$n×$n')))
                      .toList(),
                  onChanged: (v) {
                    gridSize = v ?? 5;
                    _resetGrid();
                  },
                ),
              ],
            ),
            TextField(
              controller: _wordsController,
              decoration: const InputDecoration(
                labelText: 'Hidden words (comma separated)',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  onPressed: _startPlacement,
                  child: const Text('Start Placing Words'),
                ),
                const SizedBox(width: 12),
                if (finalized)
                  FilledButton.tonal(
                    onPressed: _resetGrid,
                    child: const Text('Reset'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (currentWord.isNotEmpty && !finalized)
              Text(
                "Placing: $currentWord (letter ${currentLetterIndex + 1}/${currentWord.length})",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 8),
            Expanded(child: _buildGridPreview()),
          ],
        ),
      ),
    );
  }

  Widget _buildGridPreview() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final gridSide = min(screenWidth, screenHeight * 0.6);
    final cellSize = gridSide / gridSize;

    return Center(
      child: SizedBox(
        width: gridSide,
        height: gridSide,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(4),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridSize,
          ),
          itemCount: gridSize * gridSize,
          itemBuilder: (context, index) {
            final row = index ~/ gridSize;
            final col = index % gridSize;
            final letter = grid[row][col];
            final selected = selectedCells[row][col];
            return GestureDetector(
              onTap: () => _onCellTap(row, col),
              child: Container(
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.greenAccent.shade200
                      : Colors.orangeAccent.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    letter,
                    style: TextStyle(
                      fontSize: cellSize * 0.3,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
