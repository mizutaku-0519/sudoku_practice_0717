import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sudoku_practice_0717/views/difficulty_selection_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 60,),
            Image.asset("assets/logo.png",
            width: 300),
            SizedBox(height: 20), // Space between the text and buttons
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DifficultySelectionScreen()));
              },
              icon: Icon(Icons.play_circle_fill, size: 20), // Play Icon
              label: Text('ゲームを始める', style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor, // Change if you want a different color
                shadowColor: Colors.transparent, // Transparent shadow
                shape: RoundedRectangleBorder( // Anti-rounded sides
                  borderRadius: BorderRadius.circular(50),
               ),
              ),
            ),
            SizedBox(height: 10), // Space between the buttons
            TextButton.icon(
              onPressed: () {
                // TODO: Implement navigation to ranking screen
              },
              icon: FaIcon(FontAwesomeIcons.crown, size: 15,), // Crown Icon
              label: Text('ランキングを見る',),
            ),
          ],
        ),
      ),
    );
  }
}