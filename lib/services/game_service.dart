import 'dart:async';
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
  int helpCount = 5;
  final int totalCells = 81;
  int? selectedNumber;

  Timer? _timer;

  GameService() {
    startNewGame(difficulty: '入門');
  }

  Game? get currentGame => _currentGame;
  Game? get game => _currentGame; // 追加した部分
  String get difficulty => _currentGame?.difficulty ?? '';

  List<List<int?>>? get playerBoard => _playerBoard;

  void startNewGame({required String difficulty}) {
    _currentGame = Game(difficulty: difficulty);
    _playerBoard = List.from(_currentGame!.sudoku.map((row) => row.map((cell) => cell).toList()).toList());
    startTime = DateTime.now();
    _startTimer();

    switch (difficulty) {
      case '初級':
        maxMistakes = 5;
        helpCount = 3;
        break;
      case '中級':
        maxMistakes = 3;
        helpCount = 2;
        break;
      case '上級':
        maxMistakes = 3;
        helpCount = 2;
        break;
      case '達人級':
        maxMistakes = 2;
        helpCount = 2;
        break;
      default:
        maxMistakes = 3;
        helpCount = 5;
        break;
    }

    notifyListeners();
  }

  bool insertNumber(int row, int col, int number) {
    if (_currentGame?.originalPuzzle[row][col] == null && _playerBoard![row][col] == null && number == _currentGame!.solution[row][col]) {
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
    _stopTimer();
    notifyListeners();
    return true;
  }

  void selectCell(int row, int col) {
    if (_currentGame?.originalPuzzle[row][col] == null) {  // If the cell was not pre-filled
      selectedCell = Cell(row, col);
      notifyListeners();
    }
  }

  void selectNumber(int number) {
    selectedNumber = number;
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

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      notifyListeners();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }
}
