class Puzzle {
  final String id;
  final List<List<String>> grid;
  final List<String> hiddenWords;
  final String creator;

  Puzzle({
    required this.id,
    required this.grid,
    required this.hiddenWords,
    required this.creator,
  });
}
