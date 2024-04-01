import 'package:clear_tasks/genre.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../dummy_data.dart';

class SelectListPage extends StatelessWidget {
  final List<Genre> myList;
  final Genre onSelected;
  final Function(Genre) setSelected;

  SelectListPage(
      {required this.myList,
      required this.onSelected,
      required this.setSelected});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.white,
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Row(
            mainAxisSize: MainAxisSize.min, // 子要素のサイズに合わせる
            children: <Widget>[
              Icon(CupertinoIcons.left_chevron, size: 20.0), // `<` に似たアイコン
              Text(' New Task', style: TextStyle(fontSize: 17.0)), // テキスト
            ],
          ),
          onPressed: () => Navigator.pop(context),
        ),
        middle: Text('Select a List'),
      ),
      child: SafeArea(
        child: CupertinoListSection.insetGrouped(
          margin: EdgeInsets.only(top: 20),
          backgroundColor: CupertinoColors.white,
          children: myList.map((genre) {
            return CupertinoListTile(
              backgroundColor: CupertinoColors.white,
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(genre.title),
              ),
              leading: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: genre.color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Icon(
                    genre.icon,
                    color: CupertinoColors.white,
                    size: 20,
                  ),
                ),
              ),
              onTap: () {
                setSelected(genre);
                Navigator.pop(context);
              },
              trailing: onSelected.title == genre.title
                  ? const Icon(CupertinoIcons.check_mark,
                      color: CupertinoColors.systemBlue)
                  : null,
            );
          }).toList(),
        ),
      ),
    );
  }
}
