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
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _gameService.startNewGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool goBack = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('終了しますか？'),
            actions: [
              TextButton(
                child: Text('キャンセル'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: Text('終了する'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        );
        return goBack ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton( // AppBarの左側にあるアイコンボタンを変更
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              bool goBack = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('終了しますか？'),
                  actions: [
                    TextButton(
                      child: Text('キャンセル'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    TextButton(
                      child: Text('終了する'),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ),
              );
              if (goBack == true) {
                Navigator.of(context).pushReplacementNamed('/'); // ホーム画面に戻る
              }
            },
          ),
          title: Text('難易度：${_gameService.difficulty}'), // 難易度を表示
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                SizedBox(height: 10,),
                InformationPanel(), // InformationPanelをSudokuGridの上に配置
                SizedBox(height: 5,),
                SudokuGrid(), // SudokuGridの配置
                ControlPanel(), // ControlPanelをSudokuGridの下に配置
                NumberController(), // NumberControllerをControlPanelの下に配置
                AdvertisementArea(), // AdvertisementAreaをNumberControllerの下に配置
              ],
            ),          ),
        ),
      ),
    );
  }
}
