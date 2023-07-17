import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'views/home_screen.dart';

void main() {
  runApp(SudokuApp());
}

class SudokuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
