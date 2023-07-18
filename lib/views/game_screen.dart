import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_practice_0717/services/game_service.dart';
import 'package:sudoku_practice_0717/widgets/game_component.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameService _gameService;

  @override
  void initState() {
    super.initState();
    _gameService = Provider.of<GameService>(context, listen: false);
    _gameService.startNewGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('数独ゲーム'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // 各種コンポーネント（AppBar, InformationPanel, SudokuGrid, ControlPanel, NumberController, AdvertisementArea）を定義して、上記のColumnウィジェットの子として追加していきます
            InformationPanel(),
            SudokuGrid(),
            ControlPanel(),
            NumberController(),
            AdvertisementArea(),
          ],
        ),
      ),
    );
  }
}

//SudokuGrid()の実装

// セルを選択するメソッドを追加
void selectCell(int row, int column) {
  selectedCell = Tuple(row, column);
  notifyListeners();
}

class SudokuGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameService>(
      builder: (context, gameService, child) {
        return Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder.all(),
          children: List.generate(9, (i) {
            return TableRow(
              children: List.generate(9, (j) {
                int? cellValue = gameService.playerBoard[i][j];
                return Container(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(cellValue != null ? cellValue.toString() : ''),
                  ),
                );
              }),
            );
          }),
        );
      },
    );
  }
}