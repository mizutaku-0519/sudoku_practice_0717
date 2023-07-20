import 'package:flutter/material.dart';

class HiddenPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Color(0xFF1e50a2), width: 5),
        ),
        title: Text('見つかっちゃった！', style: TextStyle(fontSize: 14, color:Color(0xFF1e50a2), fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 左揃えに設定
          mainAxisSize: MainAxisSize.min,  // TextFieldとボタンの距離を調整
          children: <Widget>[
            Text('隠しボタンを見つけたあなたにご褒美。', style: TextStyle(fontSize: 12, color:Color(0xFF1e50a2), fontWeight: FontWeight.bold),),
            Text('Amazonギフトコード 10,000円分です。', style: TextStyle(fontSize: 12, color:Color(0xFF1e50a2), fontWeight: FontWeight.bold),),
            Text('早い者勝ちなので、ご了承ください。', style: TextStyle(fontSize: 12, color:Color(0xFF1e50a2), fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            Center(
              child: TextField(
                controller: TextEditingController(text: 'AQKP-5525BA-8XNGT'),
                readOnly: true,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 18, color: Color(0xFF1e50a2), fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10,),
            Text('また来週、どこかにおいていくかも。', style: TextStyle(fontSize: 13, color:Color(0xFF1e50a2), fontWeight: FontWeight.bold),),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
