import 'package:flutter/material.dart';
import 'package:sudoku_practice_0717/services/game_service.dart';
import 'package:sudoku_practice_0717/utils/utility.dart';
import 'package:sudoku_practice_0717/views/difficulty_selection_screen.dart';

class GameCompletionPopup extends StatefulWidget {
  final GameService gameService;

  GameCompletionPopup({required this.gameService});

  @override
  _GameCompletionPopupState createState() => _GameCompletionPopupState();
}

class _GameCompletionPopupState extends State<GameCompletionPopup> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final String clearTime;
  late final String missCount;
  final String score = '130';
  final String weeklyScore = '1,234,567';

  @override
  void initState() {
    super.initState();

    clearTime = formatDuration(widget.gameService.getElapsedTime());
    missCount = widget.gameService.getMistakeCount().toString();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400), // 1 sec for the complete animation
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0, end: 1.2), weight: 90.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.2, end: 1.0), weight: 10.0),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        backgroundColor: Colors.white.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Color(0xFF1e50a2), width: 5),
        ),
        elevation: 20,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              Text(
                'GAME CLEAR',
                style: TextStyle(
                  color: Color(0xFF1e50a2),
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    InfoRow(title: 'クリアタイム', value: clearTime),
                    InfoRow(title: 'ミス数', value: missCount),
                    InfoRow(title: 'スコア', value: score),
                    InfoRow(title: '今週の累計スコア', value: weeklyScore),
                  ],
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF1e50a2),
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DifficultySelectionScreen()));
                },
                child: Text(
                  '難易度選択画面に戻る',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String value;

  InfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
