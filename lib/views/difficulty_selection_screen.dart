import 'package:flutter/material.dart';
import 'package:sudoku_practice_0717/services/game_service.dart';
import 'package:sudoku_practice_0717/views/game_screen.dart';
import 'package:provider/provider.dart';

class Difficulty {
  final String level;
  final String stars;
  final String unlockCondition;
  bool isUnlocked;

  Difficulty({required this.level, required this.stars, required this.unlockCondition, this.isUnlocked = false});
}

class DifficultySelectionScreen extends StatelessWidget {
  final List<Difficulty> difficulties = [
    Difficulty(level: "入門者向け", stars: "★☆☆☆☆", unlockCondition: "", isUnlocked: true),
    Difficulty(level: "初級レベル", stars: "★★☆☆☆", unlockCondition: "入門を1回クリアで解放"),
    Difficulty(level: "中級レベル", stars: "★★★☆☆", unlockCondition: "初級を3回クリアで解放"),
    Difficulty(level: "上級レベル", stars: "★★★★☆", unlockCondition: "中級を5回クリアで解放"),
    Difficulty(level: "達人級", stars: "★★★★★", unlockCondition: "上級を10回クリアで解放"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('難易度選択'),
      ),
      body: ListView.builder(
        itemCount: difficulties.length,
        itemBuilder: (context, index) {
          var difficulty = difficulties[index];
          return ListTile(
            leading: Icon(
              difficulty.isUnlocked ? Icons.lock_open : Icons.lock,
              color: difficulty.isUnlocked ? Colors.green : Colors.red,
            ),
            title: Text(difficulty.level),
            subtitle: Text(difficulty.stars),
            trailing: Text(difficulty.unlockCondition),
            onTap: () {
              if (difficulty.isUnlocked) {
                context.read<GameService>().startNewGame(difficulty: difficulty.level);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameScreen()),
                );
              }
            },
          );
        },
      ),
    );
  }
}
