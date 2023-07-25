import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_practice_0717/services/game_service.dart';

class SudokuGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenWidth = screenSize.width - 16.0;
    var cellSize = screenWidth / 9.0;

    return Consumer<GameService>(
      builder: (context, gameService, child) {
        if (gameService == null || gameService.playerBoard == null || gameService.game?.originalPuzzle == null) {
          return Container(); // GameService or its boards are not initialized yet
        }

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
            border: Border.all(color: Color(0xFF1e50a2), width: 1.5), // 9x9のマスを囲む外側の枠線
          ),
          child: ClipRRect( // 追加：ClipRRectでTableをラップ
            borderRadius: BorderRadius.circular(10.0),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: List.generate(9, (i) {
                return TableRow(
                  children: List.generate(9, (j) {
                    int? cellValue = gameService.playerBoard![i][j];
                    Color? backgroundColor = Colors.white; // デフォルトの背景色を白に設定

                    //セルの背景色
                    if (gameService.selectedCell != null) {
                      if (gameService.selectedCell!.row == i && gameService.selectedCell!.col == j) {
                        backgroundColor = Colors.blueAccent[100];
                      } else if (gameService.selectedCell!.row == i ||
                          gameService.selectedCell!.col == j ||
                          (gameService.selectedCell!.row ~/ 3 == i ~/ 3 && gameService.selectedCell!.col ~/ 3 == j ~/ 3)) {
                        backgroundColor = Colors.grey[200];
                      }
                    } else if (gameService.game?.originalPuzzle[i][j] != null) {
                      backgroundColor = Colors.white;
                    } else if (gameService.isIncorrect[i][j]) {
                      backgroundColor = Colors.red[200];
                    } else {
                      backgroundColor = Colors.white;
                    }

                    //セルのテキストカラー
                    Color textColor = Colors.black;
                    if (gameService.game?.originalPuzzle[i][j] != null) {
                      textColor = Colors.black;
                    } else if (gameService.isCorrectCell(i, j)) {
                      textColor = Color(0xFF1e50a2);
                    } else if (gameService.isIncorrect[i][j]) {
                      textColor = Colors.red;
                    }

                    //セルのグリッド線
                    if (gameService.selectedCell != null) {
                      if (gameService.selectedCell!.row == i && gameService.selectedCell!.col == j) {
                        backgroundColor = Colors.blueAccent[100];
                      } else if (gameService.selectedCell!.row == i ||
                          gameService.selectedCell!.col == j ||
                          (gameService.selectedCell!.row ~/ 3 == i ~/ 3 && gameService.selectedCell!.col ~/ 3 == j ~/ 3)) {
                        backgroundColor = Colors.grey[200];
                      }
                    }


                    var thickBorderSide = BorderSide(color: Color(0xFF1e50a2), width: 1.5);  // 3x3のマスの内側の枠線
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
                        color: gameService.isIncorrect[i][j] ? Colors.red[200] : backgroundColor, // 背景色の設定
                      ),
                      child: InkWell(
                        onTap: () {
                          if (gameService.game?.originalPuzzle[i][j] == null) {
                            gameService.selectCell(i, j);
                          }
                        },
                        child: Center(
                          child: Text(
                            cellValue != null ? cellValue.toString() : '',
                            style: TextStyle(
                              fontFamily: 'Monospace',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,  // ここを textColor に変更
                            ),
                          ),
                        ),
                      ),
                    );                  }),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
