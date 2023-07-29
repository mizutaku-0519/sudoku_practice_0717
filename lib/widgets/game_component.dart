import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/game_service.dart';


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
          child: Text('残り：$remainingCellsマス',style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Monospace')),
        ),
        Flexible(
          child: Text('ミス数： $mistakeCount / ${gameService.maxMistakes}回',style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Monospace'),),
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
                  Container(
                    width: 60,  // Adjust this value as needed
                    child: Text('${twoDigits(elapsedTime.inMinutes)}:${twoDigits(elapsedTime.inSeconds % 60)}',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Monospace'), textAlign: TextAlign.right,),
                  ),
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
        // 確定ボタン
        Column(
          children: [
            Consumer<GameService>(
              builder: (context, gameService, child) {
                return IconButton(
                  icon: Icon(Icons.check, size: 30,),
                  onPressed: gameService.selectedCell != null && gameService.selectedNumber != null
                      ? () {gameService.confirmInsertion(context);} : null,
                );
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
