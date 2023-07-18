import 'package:flutter/foundation.dart';
import 'package:sudoku_practice_0717/models/game.dart';

class Cell {
  final int row;
  final int col;

  Cell(this.row, this.col);
}

class GameService extends ChangeNotifier {
  Game? _currentGame;
  List<List<int?>>? _playerBoard;
  Cell? selectedCell;

  int mistakeCount = 0;
  DateTime? startTime;

  int maxMistakes = 10;
  int helpCount = 5;  // Add this new property
  final int totalCells = 81;

  GameService() {
    startNewGame();
  }

  Game get currentGame => _currentGame!;
  String get difficulty => _currentGame!.difficulty;

  List<List<int?>> get playerBoard => _playerBoard!;

  void startNewGame({String difficulty = '入門'}) {
    _currentGame = Game(difficulty: difficulty);
    _playerBoard = List.from(_currentGame!.sudoku);
    startTime = DateTime.now();

    switch (difficulty) {
      case '中級':
        maxMistakes = 20;
        helpCount = 3;  // Adjust helpCount based on difficulty
        break;
      case '上級':
        maxMistakes = 30;
        helpCount = 2;  // Adjust helpCount based on difficulty
        break;
      case '達人級':
        maxMistakes = 30;
        helpCount = 2;  // Adjust helpCount based on difficulty
        break;
      default:
        maxMistakes = 10;
        helpCount = 5;  // Adjust helpCount based on difficulty
        break;
    }

    notifyListeners();
  }

  bool insertNumber(int row, int col, int number) {
    if (_playerBoard![row][col] == null && number == _currentGame!.solution[row][col]) {
      _playerBoard![row][col] = number;
      notifyListeners();
      return true;
    }
    mistakeCount++;
    notifyListeners();
    return false;
  }

  bool solveGame() {
    if (_currentGame == null) {
      return false;
    }
    _currentGame!.solvePuzzle();
    _playerBoard = List.from(_currentGame!.sudoku);
    notifyListeners();
    return true;
  }

  void selectCell(int row, int col) {
    selectedCell = Cell(row, col);
    notifyListeners();
  }

  int getRemainingCellsCount() {
    int remaining = 0;
    for (List<int?> row in _playerBoard!) {
      for (int? cell in row) {
        if (cell == null) {
          remaining++;
        }
      }
    }
    return remaining;
  }

  int getMistakeCount() {
    return mistakeCount;
  }

  Duration getElapsedTime() {
    return startTime != null ? DateTime.now().difference(startTime!) : Duration(seconds: 0);
  }
}
