import 'package:flutter/material.dart';

class AdvertisementArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: Center(
          child: Text(
            '広告表示エリア',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
