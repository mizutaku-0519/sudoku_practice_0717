import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_practice_0717/services/game_service.dart';
import 'package:sudoku_practice_0717/views/difficulty_selection_screen.dart';
import 'package:sudoku_practice_0717/views/game_screen.dart';
import 'package:sudoku_practice_0717/widgets/user_name_registration_popup.dart';
import 'models/game.dart';
import 'views/home_screen.dart';
import 'widgets/game_completion_popup.dart';
import 'widgets/hidden_popup.dart';

void main() {
  runApp(
    SudokuApp(),
  );
}

class SudokuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sudoku Game',
        theme: ThemeData(
          primaryColor: Color(0xFF1e50a2), // primary color
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              primary: Color(0xFF1e50a2), // button text color
            ),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white, // App bar background color
            titleTextStyle: GoogleFonts.zenKakuGothicNew(
              textStyle: Theme.of(context).textTheme.headline6,
              color: Color(0xFF1e50a2), // App bar text color
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData( // Add this line
              color: Color(0xFF1e50a2), // Set back button color
            ),
            elevation: 0, // Remove shadow from AppBar
          ),
          textTheme: GoogleFonts.zenKakuGothicNewTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}
