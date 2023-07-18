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

  GameService() {
    startNewGame();
  }

  Game get currentGame => _currentGame!;
  String get difficulty => _currentGame!.difficulty; // この行を追加します。

  List<List<int?>> get playerBoard => _playerBoard!;

  void startNewGame({String difficulty = '入門'}) {
    _currentGame = Game(difficulty: difficulty);
    _playerBoard = List.from(_currentGame!.sudoku);
    notifyListeners();
  }

  bool insertNumber(int row, int col, int number) {
    if (_playerBoard![row][col] == null && number == _currentGame!.solution[row][col]) {
      _playerBoard![row][col] = number;
      notifyListeners();
      return true;
    }
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
}
