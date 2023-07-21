import 'dart:math';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';

class Game {
  late List<List<int?>> sudoku; // プレイ中の数独パズル
  late List<List<int?>> solution; // パズルの解
  late String difficulty; // 難易度

  // 難易度ごとの空白セルの数
  static const difficultyLevels = {
    '入門': 20,
    '初級': 30,
    '中級': 40,
    '上級': 50,
    '達人級': 60,
  };

  // デフォルトの難易度を '入門' とする
  Game({String difficulty = '入門'}) {
    reset(difficulty: difficulty);
  }

  void reset({String difficulty = '入門'}) {
    this.difficulty = difficulty;
    var emptySquares = difficultyLevels[difficulty];
    if (emptySquares == null) {
      throw ArgumentError('Invalid difficulty level: $difficulty');
    }
    generatePuzzle(emptySquares);
  }

  void generatePuzzle(int emptySquares) {
    print('Generating new puzzle...');  // Add this debug output
    var sudokuGenerator = SudokuGenerator(emptySquares: emptySquares);
    this.sudoku = sudokuGenerator.newSudoku.map((row) => row.map((cell) => cell == 0 ? null : cell).toList()).toList();
    this.solution = sudokuGenerator.newSudokuSolved;
  }

  void solvePuzzle() {
    this.sudoku = SudokuSolver.solve(sudoku);
  }
}
