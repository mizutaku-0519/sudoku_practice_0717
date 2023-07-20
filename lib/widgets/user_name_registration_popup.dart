import 'package:flutter/material.dart';

class UsernameRegistrationPopup extends StatefulWidget {
  final String userID;
  final String currentUsername; // 現在のユーザー名

  UsernameRegistrationPopup({required this.userID, this.currentUsername = "無職になりたい"}); // 現在のユーザー名はデフォルトで "John Doe"

  @override
  _UsernameRegistrationPopupState createState() => _UsernameRegistrationPopupState();
}

class _UsernameRegistrationPopupState extends State<UsernameRegistrationPopup> {
  final _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(  // Paddingを追加
      padding: const EdgeInsets.all(8.0),
      child: AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Color(0xFF1e50a2), width: 5),
        ),
        title: Text('ユーザーID｜${widget.userID}', style: TextStyle(fontSize: 14, color:Colors.black, fontWeight: FontWeight.normal), textAlign: TextAlign.left,),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 左揃えに設定
          mainAxisSize: MainAxisSize.min,  // TextFieldとボタンの距離を調整
          children: <Widget>[
            SizedBox(height: 10),
            Text('現在のユーザー名は「${widget.currentUsername}」です',style: TextStyle(fontSize: 10, color:Color(0xFF1e50a2), fontWeight: FontWeight.bold),),  // 現在のユーザー名を表示
            SizedBox(height: 10),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'ユーザー名を登録',
                focusedBorder: UnderlineInputBorder(  // 下線のみに設定
                  borderSide: BorderSide(color: Color(0xFF1e50a2), width: 1.0),
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('キャンセル'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          SizedBox(width: 0,),
          Padding( // 登録ボタンの右に余白を追加
            padding: const EdgeInsets.only(right: 10.0),
            child: ElevatedButton(  // ElevatedButtonに変更
              child: Text('登録', style: TextStyle(color: Colors.white),),  // テキストカラーを白に変更
              onPressed: () {
                String username = _usernameController.text;
                // TODO: ユーザー名を保存する処理を書く
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF1e50a2), // ボタンカラーを変更
                shadowColor: Colors.transparent, //  影をなしに
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}
