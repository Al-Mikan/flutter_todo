import 'package:clear_tasks/models/genre.dart';
import 'package:flutter/cupertino.dart';

import 'package:clear_tasks/main.dart';
import 'task_list_page.dart';
import '../repositories/genre_repository.dart';
import '../utils/icon_utils.dart';

class EditListPage extends StatefulWidget {
  const EditListPage(
      {super.key, required this.genre, required this.genreRepository});

  final Genre? genre;
  final GenreRepository genreRepository;

  @override
  State<EditListPage> createState() => _EditListPageState();
}

class _EditListPageState extends State<EditListPage> {
  late TextEditingController _listNameController;

  late Color selectedColor; // 選択された色を保持する変数
  late IconData selectedIcon; // 選択されたアイコンを保持する変数

  @override
  void initState() {
    super.initState();
    if (widget.genre != null) {
      selectedColor = Color(widget.genre!.color);
      selectedIcon = IconUtils.getIconFromCodePoint(widget.genre!.icon);
    } else {
      selectedColor = colors[0];
      selectedIcon = icons[0];
    }
    _listNameController = TextEditingController(text: widget.genre?.title);
    _listNameController.addListener(_updateState);
  }

  @override
  void dispose() {
    _listNameController.dispose();
    super.dispose();
  }

  void _updateState() {
    setState(() {
      // setState内で何もしなくても、_titleController.textの状態が変わるたびに
      // buildメソッドが再実行され、UIが更新される
    });
  }

  void _udpateList(isCreatingNewList, Genre list, listId) async {
    if (!isCreatingNewList) {
      list.id = listId;
    }
    await widget.genreRepository.addGenre(list);
    if (mounted) {
      Navigator.pop(context, list);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCreatingNewList = widget.genre == null;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      navigationBar: CupertinoNavigationBar(
        middle: Text(isCreatingNewList
            ? 'Create new list'
            : 'Edit List “${widget.genre?.title}”'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context, widget.genre),
        ),
        trailing: CupertinoButton(
          onPressed: _listNameController.text.isNotEmpty
              ? () => {
                    _udpateList(
                        isCreatingNewList,
                        Genre(
                            title: _listNameController.text,
                            color: selectedColor.value,
                            icon: selectedIcon.codePoint,
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now()),
                        widget.genre?.id),
                  }
              : null,
          padding: EdgeInsets.zero,
          child: Text(
            'Done',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: _listNameController.text.isNotEmpty
                  ? CupertinoColors.activeBlue
                  : CupertinoColors.inactiveGray,
            ),
          ),
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
            controller: _listNameController,
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
                    ? Border.all(color: CupertinoColors.systemGrey, width: 3)
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
    CupertinoColors.black,
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
