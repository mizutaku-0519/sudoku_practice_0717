import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_service.dart';

//機能実装済み


//デザイン実装済み
class SudokuGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenWidth = screenSize.width - 16.0;
    var cellSize = screenWidth / 9.0;

    return Consumer<GameService>(
      builder: (context, gameService, child) {
        return Container(
          decoration: BoxDecoration(
            color: Color(0xFF1e50a2),
            borderRadius: BorderRadius.circular(5.0), // 9x9のマスの外枠に丸みを追加
            boxShadow: [ // 影を追加
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0, 1),
              ),
            ],
            border: Border.all(color: Color(0xFF1e50a2), width: 2), // 9x9のマスを囲む外側の枠線
          ),
          child: ClipRRect( // 追加：ClipRRectでTableをラップ
            borderRadius: BorderRadius.circular(10.0),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: List.generate(9, (i) {
                return TableRow(
                  children: List.generate(9, (j) {
                    int? cellValue = gameService.playerBoard[i][j];
                    Color? backgroundColor = Colors.white; // デフォルトの背景色を白に設定
                    if (gameService.selectedCell != null) {
                      if (gameService.selectedCell!.row == i && gameService.selectedCell!.col == j) {
                        backgroundColor = Colors.blueAccent[100];
                      } else if (gameService.selectedCell!.row == i ||
                          gameService.selectedCell!.col == j ||
                          (gameService.selectedCell!.row ~/ 3 == i ~/ 3 && gameService.selectedCell!.col ~/ 3 == j ~/ 3)) {
                        backgroundColor = Colors.grey[300];
                      }
                    }

                    var thickBorderSide = BorderSide(color: Color(0xFF1e50a2), width: 2.0);  // 3x3のマスの内側の枠線
                    var thinBorderSide = BorderSide(color: Colors.grey, width: 0.5);
                    var leftBorder = j % 3 == 0 ? thickBorderSide : thinBorderSide;
                    var topBorder = i % 3 == 0 ? thickBorderSide : thinBorderSide;
                    var rightBorder = (j + 1) % 3 == 0 ? thickBorderSide : thinBorderSide;
                    var bottomBorder = (i + 1) % 3 == 0 ? thickBorderSide : thinBorderSide;

                    return Container(
                      width: cellSize,
                      height: cellSize,
                      decoration: BoxDecoration(
                        border: Border(
                          top: topBorder,
                          left: leftBorder,
                          right: rightBorder,
                          bottom: bottomBorder,
                        ),
                        color: backgroundColor,
                      ),
                      child: InkWell(
                        onTap: () {
                          gameService.selectCell(i, j);
                        },
                        child: Center(
                          child: Text(
                            cellValue != null ? cellValue.toString() : '',
                            style: TextStyle(fontFamily: 'Monospace',fontSize: 18), // フォントをMonospaceに設定
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}

class InformationPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // GameServiceから状態を取得する
    GameService gameService = Provider.of<GameService>(context);

    // 残りマス数、ミス数、経過時間を取得する
    int remainingCells = gameService.getRemainingCellsCount();
    int mistakeCount = gameService.getMistakeCount();
    Duration elapsedTime = gameService.getElapsedTime();

    String twoDigits(int n) => n.toString().padLeft(2, "0");  // Add this helper function

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          child: Text('残りマス数：$remainingCells/${gameService.totalCells}',style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ),
        Flexible(
          child: Text('ミス数：$mistakeCount/${gameService.maxMistakes}回',style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),),
        ),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.timer_outlined, size: 20,),
                  SizedBox(width: 10),  // Give some spacing
                  Text('${twoDigits(elapsedTime.inMinutes)}:${twoDigits(elapsedTime.inSeconds % 60)}',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                ],
              ),  // Timer icon
            ],
          ),
        ),
      ],
    );
  }
}

class ControlPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // GameServiceから状態を取得する
    GameService gameService = Provider.of<GameService>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            IconButton(
              icon: Icon(Icons.undo, size: 30,),
              onPressed: () {
                // TODO: ここで戻る機能を実装
              },
            ),
            Text('戻る'),
          ],
        ), //戻るボタン
        Column(
          children: [
            IconButton(
              icon: Icon(Icons.edit, size: 30,),
              onPressed: () {
                // TODO: ここで下書き機能を実装
              },
            ),
            Text('下書き'),
          ],
        ), //下書きボタン
        Column(
          children: [
            IconButton(
              icon: Icon(Icons.check, size: 30,),
              onPressed: () {
                // TODO: ここで数字の入力機能を実装
              },
            ),
            Text('確定'),
          ],
        ),
        Column(
          children: [
            Stack(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.emoji_flags, size: 35,),
                  onPressed: () {
                    // TODO: ここでお助け機能を実装
                    gameService.helpCount--;  // お助け機能を使うと回数が1減る
                  },
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Color(0xFF9F2641),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 23,
                      minHeight: 23,
                    ),
                    child: Text(
                      gameService.helpCount.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
            Text('お助け'),
          ],
        ),
      ],
    );
  }
}

class NumberController extends StatelessWidget {
  void _onChipTap(BuildContext context, int number) {
    Provider.of<GameService>(context, listen: false).selectNumber(number);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameService>(
      builder: (context, gameService, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List<Widget>.generate(9, (index) {
            int number = index + 1;
            bool isSelected = gameService.selectedNumber == number;
            return GestureDetector(
              onTap: () => _onChipTap(context, number),
              child: Container(
                decoration: isSelected
                    ? BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 2.0,
                      color: Color(0xFF1e50a2),
                    ),
                  ),
                )
                    : null,
                child: Text(
                  '$number',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Color(0xFF1e50a2) : Colors.black,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class AdvertisementArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: Center(
          child: Text(
            '広告表示エリア',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

