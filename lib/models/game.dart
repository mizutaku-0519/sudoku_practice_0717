import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';

class Game {
  late List<List<int?>> sudoku; // プレイ中の数独パズル
  late List<List<int?>> solution; // パズルの解

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
    var emptySquares = difficultyLevels[difficulty];
    if (emptySquares == null) {
      throw ArgumentError('Invalid difficulty level: $difficulty');
    }
    generatePuzzle(emptySquares);
  }

  void generatePuzzle(int emptySquares) {
    var sudokuGenerator = SudokuGenerator(emptySquares: emptySquares ?? 20); // nullの場合はデフォルト値として20を使用
    this.sudoku = sudokuGenerator.newSudoku;
    this.solution = sudokuGenerator.newSudokuSolved;
  }

  void solvePuzzle() {
    this.sudoku = SudokuSolver.solve(sudoku);
  }
}
