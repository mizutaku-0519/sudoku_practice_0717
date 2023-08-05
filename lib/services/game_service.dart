import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sudoku_practice_0717/models/game.dart';
import 'package:sudoku_practice_0717/widgets/game_completion_popup.dart';

// ゲームのセルを表すためのクラス
class Cell {
  final int row;
  final int col;

  Cell(this.row, this.col);
}

// セルに数字を挿入した結果を表すためのEnum
enum InsertResult {
  correct,
  incorrect,
  alreadyFilled,
}

// ゲームの状態を管理するためのサービスクラス
class GameService extends ChangeNotifier {
  Game? _currentGame;
  List<List<int?>>? _playerBoard;
  Cell? selectedCell;
  InsertResult? lastResult;
  List<List<bool>>? initialCells;
  List<List<int?>>? provisionalBoard;
  int mistakeCount = 0;
  DateTime? startTime;
  int maxMistakes = 10;
  int helpCount = 5;
  final int totalCells = 81;
  int? selectedNumber; // 選択された数字を保持する
  Timer? _timer;

  // コンストラクタで新しいゲームを開始します。
  GameService() {
    startNewGame(difficulty: '入門');
  }

  // 現在のゲームの状態や難易度などを取得するためのgetter
  Game? get currentGame => _currentGame;
  Game? get game => _currentGame; // 追加した部分
  String get difficulty => _currentGame?.difficulty ?? '';

  List<List<int?>>? get playerBoard => _playerBoard;

  // 新しいゲームを開始するためのメソッド
  void startNewGame({required String difficulty}) {
    mistakeCount = 0;  // 新たなゲームを開始するたびにミスカウントをリセットします
    _currentGame = Game(difficulty: difficulty);
    _playerBoard = List.from(
        _currentGame!.sudoku.map((row) => row.map((cell) => cell).toList())
            .toList());
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

      print('Original Puzzle:');
      _currentGame?.originalPuzzle.forEach((row) {
        print(row);
      });


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

  // プレイヤーがセルに数字を挿入した結果を追跡する2次元リスト
  List<List<bool>> isIncorrect = List.generate(9, (_) => List.filled(9, false));


  // プレイヤーが指定したセルに指定した数字を仮に挿入するためのメソッド
  InsertResult insertProvisionalNumber(int row, int col, int number) {
    if (_currentGame?.originalPuzzle[row][col] != null ||
        isCorrectCell(row, col)) {
      return InsertResult.alreadyFilled;
    }

    if (number == _currentGame!.solution[row][col]) {
      provisionalBoard![row][col] = number;
      lastResult = InsertResult.correct;
    } else {
      provisionalBoard![row][col] = number;
      lastResult = InsertResult.incorrect;
    }

    notifyListeners();
    return lastResult!;
  }

  // ゲームが終了したかどうかを確認するためのメソッド
  void checkCompletion(BuildContext context) {
    // 最後のセルでミスをした場合でも、ゲームが終了しないようにするために、
    // 全てのセルが埋まっているかどうかを確認する前に、
    // 正しい解答が全てのセルに埋まっているかどうかをチェックします。
    bool isAllCellsCorrect = true;
    for (int row = 0; row < 9; ++row) {
      for (int col = 0; col < 9; ++col) {
        if (!isCorrectCell(row, col)) {
          isAllCellsCorrect = false;
          break;
        }
      }
      if (!isAllCellsCorrect) {
        break;
      }
    }

    // 全てのセルが正しく埋まっており、ミスが許容範囲内であれば、ゲームを終了します。
    if (isAllCellsCorrect && mistakeCount < maxMistakes) {
      _stopTimer();
      showDialog(
        context: context,
        builder: (BuildContext context) => GameCompletionPopup(gameService: this),
      );
    }
  }

  // 現在のゲームを解決するためのメソッド
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

  // プレイヤーが指定したセルを選択するためのメソッド
  void selectCell(int row, int col) {
    // 元々の数字があるか、またはすでに正しい数字が入っている場合はセルを選択しない
    if (_currentGame?.originalPuzzle[row][col] != null || isCorrectCell(row, col)) {
      print('Cell is not selectable');
      return;
    }
    selectedCell = Cell(row, col);
    print('Selected cell: ($row, $col)');
    selectedNumber = provisionalBoard![row][col] ?? 0;  // 選択したセルの仮の入力を取得します。nullの場合は0を代入します
    notifyListeners();
  }

  // プレイヤーが指定した数字を選択するためのメソッド
  void selectNumber(int number) {
    if (selectedCell != null) {
      // _playerBoard![selectedCell!.row][selectedCell!.col] = number;
      provisionalBoard![selectedCell!.row][selectedCell!.col] = number;
      // ここで正解かどうかを判断する
      if (number == _currentGame!.solution[selectedCell!.row][selectedCell!.col]) {
        lastResult = InsertResult.correct;
        print('Selected number: $number for cell: (${selectedCell!.row}, ${selectedCell!.col}) is correct');
      } else {
        lastResult = InsertResult.incorrect;
        print('Selected number: $number for cell: (${selectedCell!.row}, ${selectedCell!.col}) is incorrect');
      }
    } else {
      print('No cell is selected');
    }
    selectedNumber = number;
    notifyListeners();
  }


// プレイヤーが仮に挿入した数字を確定するためのメソッド
  void confirmInsertion(BuildContext context) {
    if (_playerBoard![selectedCell!.row][selectedCell!.col] == provisionalBoard![selectedCell!.row][selectedCell!.col]) {
      print('Same number already confirmed for this cell');
      return;
    }

    if (selectedCell != null && provisionalBoard![selectedCell!.row][selectedCell!.col] != null) {
      if (_currentGame?.originalPuzzle[selectedCell!.row][selectedCell!.col] != null) {
        print('Cell contains original number');
        return;
      }

      if (_currentGame?.originalPuzzle[selectedCell!.row][selectedCell!.col] != null || isCorrectCell(selectedCell!.row, selectedCell!.col)) {
        print('Cell is not fillable');
        return;
      }


      if (provisionalBoard![selectedCell!.row][selectedCell!.col] == _currentGame!.solution[selectedCell!.row][selectedCell!.col]) {
        _playerBoard![selectedCell!.row][selectedCell!.col] = provisionalBoard![selectedCell!.row][selectedCell!.col];
        isIncorrect[selectedCell!.row][selectedCell!.col] = false;
        lastResult = InsertResult.correct;
        print('Confirmed insertion: ${provisionalBoard![selectedCell!.row][selectedCell!.col]} for cell: (${selectedCell!.row}, ${selectedCell!.col})');
        provisionalBoard![selectedCell!.row][selectedCell!.col] = null;  // Correct answer, so reset the provisional value
      } else {
        _playerBoard![selectedCell!.row][selectedCell!.col] = provisionalBoard![selectedCell!.row][selectedCell!.col];
        isIncorrect[selectedCell!.row][selectedCell!.col] = true;
        incrementMistakeCount();
        print('Mistake count increased: $mistakeCount');
        lastResult = InsertResult.incorrect;
        print('Incorrect insertion: ${provisionalBoard![selectedCell!.row][selectedCell!.col]} for cell: (${selectedCell!.row}, ${selectedCell!.col})');
        // Do not reset the provisional value if the answer is incorrect
      }
      // provisionalBoard![selectedCell!.row][selectedCell!.col] = null;
      selectedNumber = null;
      notifyListeners();
    } else {
      print('No cell is selected or no provisional number');
    }

    // Always check completion after insertion
    if (getRemainingCellsCount() == 0 && mistakeCount < maxMistakes) {
      checkCompletion(context);
    }
  }

  // 残りの未解決のセルの数を取得するためのメソッド
  int getRemainingCellsCount() {
    int remaining = 0;
    for (int row = 0; row < 9; ++row) {
      for (int col = 0; col < 9; ++col) {
        if (_playerBoard![row][col] == null) {
          remaining++;
        }
      }
    }
    return remaining;
  }

  void selectAndValidateNumber(int number) {
    if (selectedCell != null) {
      _playerBoard![selectedCell!.row][selectedCell!.col] = number;
      if (_playerBoard![selectedCell!.row][selectedCell!.col] == _currentGame!.solution[selectedCell!.row][selectedCell!.col]) {
        print('Selected number: $number for cell: (${selectedCell!.row}, ${selectedCell!.col}) is correct');
      } else {
        print('Selected number: $number for cell: (${selectedCell!.row}, ${selectedCell!.col}) is incorrect');
      }
    } else {
      print('No cell is selected');
    }
    notifyListeners();
  }

  // 残りの未解決のセルの数を取得するためのメソッド（仮の盤面用）
  int getProvisionalCellsCount() {
    int remaining = 0;
    for (List<int?> row in provisionalBoard!) {
      for (int? cell in row) {
        if (cell == null) {
          remaining++;
        }
      }
    }
    return remaining;
  }


  // 最後に挿入した数字が間違っていたかどうかを確認するためのメソッド
  bool isMistake() {
    return lastResult == InsertResult.incorrect;
  }

  // ミスした回数を増やすためのメソッド
  void incrementMistakeCount() {
    print('Incrementing mistake count. Current count: $mistakeCount');  // Add this line
    mistakeCount++;
    notifyListeners();
  }

  // 指定したセルが正しく解決されているかどうかを確認するためのメソッド
  bool isCorrectCell(int row, int col) {
    if (_playerBoard![row][col] == null) {
      return false;
    }
    return _currentGame?.solution[row][col] == _playerBoard![row][col];  // solution をチェックするように変更
  }

  // ミスした回数を取得するためのメソッド
  int getMistakeCount() {
    return mistakeCount;
  }

  // ゲームの経過時間を取得するためのメソッド
  Duration getElapsedTime() {
    return startTime != null ? DateTime.now().difference(startTime!) : Duration(seconds: 0);
  }

  // タイマーを開始・停止するための内部メソッド
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