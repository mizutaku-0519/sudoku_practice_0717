import 'package:flutter/material.dart';
import 'package:sudoku_practice_0717/views/game_screen.dart';

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
    Difficulty(level: "中級レベル", stars: "★★★☆☆", unlockCondition: "初級を5回クリアで解放"),
    Difficulty(level: "上級レベル", stars: "★★★★☆", unlockCondition: "中級を10回クリアで解放"),
    Difficulty(level: "達人級レベル", stars: "★★★★★", unlockCondition: "上級を15回クリアで解放"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ゲームを開始する"),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 50,),
          Expanded(
            child: Center(
              child: ListView.builder(
                  itemCount: difficulties.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 7),
                      child: ElevatedButton(
                        onPressed: difficulties[index].isUnlocked ? () {
                          // Implement your navigation logic here
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameScreen(),
                            ),
                          );
                        } : null,
                        style: ElevatedButton.styleFrom(
                          primary: difficulties[index].isUnlocked ? Color(0xFF1e50a2) : Color(0xFFBDBDB7),
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.all(10),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 10), // Space between the icon and the text
                            Icon(difficulties[index].isUnlocked ? Icons.star : Icons.lock), // Replace with your preferred icon
                            SizedBox(width: 30), // Space between the icon and the text
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(difficulties[index].level, style: TextStyle(fontSize: 20),),
                                Text(difficulties[index].stars, ),
                                Text(difficulties[index].unlockCondition),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
              ),
            ),
          ),
          Container( // This will be the ad banner
            height: 50,
            width: 250,// Adjust to the size of your ad banner
            color: Colors.grey, // Just for demonstration, remove in your code
            child: Center(
              child: Text('広告を表示する', style: TextStyle(color: Colors.white),), // Just for demonstration, replace with your Admob or other ad banner widget
            ),
          ),
          SizedBox(height: 40,)
        ],
      ),
    );
  }
}
