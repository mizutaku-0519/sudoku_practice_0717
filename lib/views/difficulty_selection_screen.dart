import 'package:flutter/material.dart';
import 'package:sudoku_practice_0717/services/game_service.dart';
import 'package:sudoku_practice_0717/views/game_screen.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_practice_0717/views/home_screen.dart';

class Difficulty {
  final String level;
  final String stars;
  final String unlockCondition;
  bool isUnlocked;

  Difficulty({required this.level, required this.stars, required this.unlockCondition, this.isUnlocked = false});
}

class DifficultySelectionScreen extends StatelessWidget {
  final List<Difficulty> difficulties = [
    Difficulty(level: "入門", stars: "★☆☆☆☆", unlockCondition: "", isUnlocked: true),
    Difficulty(level: "初級", stars: "★★☆☆☆", unlockCondition: "入門を1回クリアで解放", isUnlocked: true),
    Difficulty(level: "中級", stars: "★★★☆☆", unlockCondition: "初級を3回クリアで解放", isUnlocked: true),
    Difficulty(level: "上級", stars: "★★★★☆", unlockCondition: "中級を5回クリアで解放", isUnlocked: true),
    Difficulty(level: "達人級", stars: "★★★★★", unlockCondition: "上級を10回クリアで解放",isUnlocked: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('難易度選択'),
        leading: IconButton(
          icon: Icon(Icons.expand_more_outlined),
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  var begin = Offset(0.0, -1.0);
                  var end = Offset.zero;
                  var curve = Curves.ease;
                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          },
        ),
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