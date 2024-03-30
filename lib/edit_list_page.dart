import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditListPage extends StatefulWidget {
  final String genre;

  const EditListPage({super.key, required this.genre});

  @override
  State<EditListPage> createState() => _EditListPageState();
}

class _EditListPageState extends State<EditListPage> {
  Color? selectedColor = CupertinoColors.systemRed; // 選択された色を保持する変数
  IconData? selectedIcon = CupertinoIcons.list_bullet; // 選択されたアイコンを保持する変数
  @override
  Widget build(BuildContext context) {
    final isCreatingNewList = widget.genre.isEmpty;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      navigationBar: CupertinoNavigationBar(
        middle: Text(isCreatingNewList
            ? 'Create new list'
            : 'Edit List “${widget.genre}”'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        trailing: CupertinoButton(
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          child:
              const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        border: null,
        backgroundColor: CupertinoColors.extraLightBackgroundGray,
      ),
      child: SingleChildScrollView(
        // スクロール可能にするためにSingleChildScrollViewを使用
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNameField(),
            _buildColorPicker(),
            _buildIconPicker()
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: selectedColor, // Containerの背景色
              borderRadius: BorderRadius.circular(6), // 角丸の半径を指定
            ),
            child: Center(
              child: Icon(selectedIcon, color: CupertinoColors.white, size: 28),
            ),
          ),
          const SizedBox(height: 16),
          CupertinoTextField(
            padding: const EdgeInsets.all(14.0),
            autofocus: true,
            controller: TextEditingController(text: widget.genre),
            clearButtonMode: OverlayVisibilityMode.editing,
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey5,
              borderRadius: BorderRadius.circular(8),
            ),
            placeholder: 'List Name',
            placeholderStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: CupertinoColors.systemGrey2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPicker() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: colors.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedColor = colors[index];
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: colors[index],
                shape: BoxShape.circle,
                border: selectedColor == colors[index]
                    ? Border.all(color: CupertinoColors.black, width: 2)
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIconPicker() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true, // GridViewの高さを中身に合わせる
        physics: const NeverScrollableScrollPhysics(), // GridViewのスクロールを無効化
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6, // 1行あたりのアイテム数
          crossAxisSpacing: 16, // アイテム間の横スペース
          mainAxisSpacing: 16, // アイテム間の縦スペース
        ),
        itemCount: icons.length, // アイコンの数
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIcon = icons[index]; // 選択されたアイコンを更新
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                shape: BoxShape.circle,
                border: selectedIcon == icons[index]
                    ? Border.all(color: CupertinoColors.systemGrey, width: 3)
                    : null,
              ),
              child: Icon(
                icons[index],
                color: CupertinoColors.systemGrey4.darkColor,
                size: 20,
              ),
            ),
          );
        },
      ),
    );
  }

  // 使用する色のリスト
  final List<Color> colors = [
    CupertinoColors.systemRed,
    CupertinoColors.systemOrange,
    CupertinoColors.systemYellow,
    CupertinoColors.systemGreen,
    CupertinoColors.systemMint,
    CupertinoColors.systemCyan,
    CupertinoColors.systemBlue,
    CupertinoColors.systemIndigo,
    CupertinoColors.systemPink,
    CupertinoColors.systemPurple,
    CupertinoColors.systemBrown,
    CupertinoColors.systemGrey,
  ];
  final List<IconData> icons = [
    CupertinoIcons.list_bullet,
    CupertinoIcons.bookmark_fill,
    CupertinoIcons.map_pin,
    CupertinoIcons.doc_fill,
    CupertinoIcons.flag_fill,
    CupertinoIcons.person_2_fill,
    CupertinoIcons.money_dollar_circle_fill,
    CupertinoIcons.book_fill,
    CupertinoIcons.cart_fill,
    CupertinoIcons.paw,
    CupertinoIcons.lightbulb_fill,
    CupertinoIcons.house_fill,
    //図形
    CupertinoIcons.square_fill,
    CupertinoIcons.circle_fill,
    CupertinoIcons.triangle_fill,
    CupertinoIcons.hexagon_fill,
    CupertinoIcons.heart_fill,
    CupertinoIcons.bolt_fill,
  ];
}
