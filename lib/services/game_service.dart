import 'package:flutter/foundation.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';
import 'package:sudoku_practice_0717/models/game.dart';

class GameService extends ChangeNotifier {
  Game? _currentGame;
  List<List<int?>>? _playerBoard;

  GameService() {
    startNewGame();
  }

  Game get currentGame => _currentGame!;

  List<List<int?>> get playerBoard => _playerBoard!;

  void startNewGame({String difficulty = '入門'}) {
    _currentGame = Game(difficulty: difficulty);
    _playerBoard = List.from(_currentGame!.sudoku);
    notifyListeners();
  }

  bool insertNumber(int row, int col, int number) {
    if (_playerBoard![row][col] == null && SudokuUtilities.isValidSudoku(_playerBoard!, row: row, col: col, number: number)) {
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
}
