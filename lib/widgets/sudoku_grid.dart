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
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0, 1),
              ),
            ],
            border: Border.all(color: Color(0xFF1e50a2), width: 1.5),
          ),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: List.generate(9, (i) {
                return TableRow(
                  children: List.generate(9, (j) {
                    int? cellValue;
                    if (gameService.game?.originalPuzzle[i][j] != null) {
                      cellValue = gameService.playerBoard![i][j];
                    } else if (gameService.isCorrectCell(i, j)) {
                      cellValue = gameService.playerBoard![i][j];
                    } else if (gameService.isIncorrect[i][j]) {
                      cellValue = gameService.provisionalBoard![i][j];
                    } else {
                      cellValue = gameService.provisionalBoard![i][j];
                    }

                    Color? backgroundColor = Colors.white;

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

                    Color textColor = Colors.black;
                    if (gameService.game?.originalPuzzle[i][j] != null) {
                      textColor = Colors.black;
                    } else if (gameService.isCorrectCell(i, j)) {
                      textColor = Color(0xFF1e50a2);
                    } else if (gameService.isIncorrect[i][j]) {
                      textColor = Colors.red;
                    }

                    var thickBorderSide = BorderSide(color: Color(0xFF1e50a2), width: 1.5);
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
                        color: gameService.isIncorrect[i][j] ? Colors.red[200] : backgroundColor,
                      ),
                      child: InkWell(
                        onTap: () {
                          if (gameService.game?.originalPuzzle[i][j] == null) {
                            gameService.selectCell(i, j);
                            gameService.notifyListeners();  // Update the UI whenever a cell is selected
                          }
                        },
                        child: Center(
                          child: Text(
                            cellValue != null
                                ? cellValue.toString()
                                : gameService.provisionalBoard != null && gameService.provisionalBoard![i][j] != null
                                ? gameService.provisionalBoard![i][j]?.toString() ?? ''
                                : '',
                            style: TextStyle(
                              fontFamily: 'Monospace',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: gameService.provisionalBoard != null && gameService.provisionalBoard![i][j] != null
                                  ? Colors.black45
                                  : textColor,
                            ),
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
