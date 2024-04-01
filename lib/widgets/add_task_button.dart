import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddTaskButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddTaskButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center, // ボタンを右寄せにする
      child: CupertinoButton(
        onPressed: () {
          onPressed();
        },
        child: const Row(
          mainAxisSize: MainAxisSize.min, // アイコンとテキストのサイズに合わせてRowのサイズを最小化
          children: [
            Icon(
              CupertinoIcons.add_circled_solid, // + アイコン
              size: 24, // アイコンのサイズ（必要に応じて調整）
            ),
            SizedBox(width: 4), // アイコンとテキストの間に少しスペースを追加
            Text(
              'Add Task',
              style: TextStyle(fontWeight: FontWeight.bold), // テキストを太字にする
            ),
          ],
        ),
      ),
    );
  }
}
