import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_practice_0717/services/game_service.dart';

class NumberController extends StatelessWidget {
  void _onChipTap(BuildContext context, int number) {
    Provider.of<GameService>(context, listen: false).selectNumber(number);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameService>(
      builder: (context, gameService, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List<Widget>.generate(9, (index) {
            int number = index + 1;
            bool isSelected = gameService.selectedNumber == number;
            return GestureDetector(
              onTap: () => _onChipTap(context, number),
              child: Container(
                decoration: isSelected
                    ? BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 2.0,
                      color: Color(0xFF1e50a2),
                    ),
                  ),
                )
                    : null,
                child: Text(
                  '$number',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Color(0xFF1e50a2) : Colors.black,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
