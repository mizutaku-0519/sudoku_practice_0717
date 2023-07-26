import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sudoku_practice_0717/models/game.dart';

class Cell {
  final int row;
  final int col;

  Cell(this.row, this.col);
}

enum InsertResult {
  correct,
  incorrect,
  alreadyFilled,
}

class GameService extends ChangeNotifier {
  Game? _currentGame;
  List<List<int?>>? _playerBoard;
  Cell? selectedCell;
  InsertResult? lastResult;
  List<List<bool>>? initialCells;
  // 各セルの仮の入力を保持するための新たな2次元配列
  List<List<int?>>? provisionalBoard;


  int mistakeCount = 0;
  DateTime? startTime;

  int maxMistakes = 10;
  int helpCount = 5;
  final int totalCells = 81;
  int? selectedNumber;  // 選択された数字を保持する

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
    provisionalBoard = List.generate(9, (_) => List<int?>.filled(9, null));
    startTime = DateTime.now();
    _startTimer();

    initialCells = List<List<bool>>.generate(
      9,
          (_) => List<bool>.filled(9, false),
    );

    for (int i = 0; i < 9; ++i) {
      for (int j = 0; j < 9; ++j) {
        initialCells![i][j] = _currentGame!.originalPuzzle[i][j] != null;
      }
    }


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

  // 選択したセルが正しくないかどうかを追跡する2次元リスト
  List<List<bool>> isIncorrect = List.generate(9, (_) => List.filled(9, false));

  InsertResult insertNumber(int row, int col, int number) {
    if (_currentGame?.originalPuzzle[row][col] != null) {
      return InsertResult.alreadyFilled;
    }
    if (number == _currentGame!.solution[row][col]) {
      _playerBoard![row][col] = number;
      isIncorrect[row][col] = false;
      lastResult = InsertResult.correct;
    } else {
      _playerBoard![row][col] = number;
      isIncorrect[row][col] = true;
      mistakeCount++;
      lastResult = InsertResult.incorrect;
    }
    notifyListeners();
    return lastResult!;
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
      print('Selected cell: ($row, $col)');
      selectedNumber = provisionalBoard![row][col] ?? 0;  // 選択したセルの仮の入力を取得します。nullの場合は0を代入します
      notifyListeners();
    }
  }



  void selectNumber(int number) {
    if (selectedCell != null) {
      // 選択したセルの仮の入力を更新します
      provisionalBoard![selectedCell!.row][selectedCell!.col] = number;
    }
    selectedNumber = number;
    notifyListeners();
  }


  void confirmInsertion() {
    if (selectedCell != null && selectedNumber != null) {
      lastResult = insertNumber(selectedCell!.row, selectedCell!.col, selectedNumber!);
      provisionalBoard![selectedCell!.row][selectedCell!.col] = null;  // 確定したら、そのセルの仮の入力をリセットします
      selectedNumber = null;
      notifyListeners();
    }
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



  bool isMistake() {
    return lastResult == InsertResult.incorrect;
  }

  // 追加したメソッド
  void incrementMistakeCount() {
    mistakeCount++;
    notifyListeners();
  }

  // 追加したメソッド
  bool isCorrectCell(int row, int col) {
    if (_playerBoard![row][col] == null) {
      return false;
    }
    return _currentGame?.solution[row][col] == _playerBoard![row][col];  // solution をチェックするように変更
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
