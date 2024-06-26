import 'package:clear_tasks/models/genre.dart';
import 'package:clear_tasks/models/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'selected_myList_page.dart';
import '../utils/icon_utils.dart';
import '../repositories/genre_repository.dart';
import '../repositories/task_repository.dart';

class AddTaskPage extends StatefulWidget {
  AddTaskPage(
      {super.key,
      required this.selectedMyList,
      required this.genreRepository,
      required this.taskRepository});

  //引数にlist
  Genre selectedMyList;
  final GenreRepository genreRepository;
  final TaskRepository taskRepository;

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool isDateSelected = false;
  bool isTimeSelected = false;
  bool isStarSelected = false;
  DateTime selectedDate = DateTime.now();
  DateTime selectedTime = DateTime.now();

  List<Genre> myLists = [];

  @override
  void initState() {
    super.initState();
    _loadLists();
    _titleController.addListener(_updateState);
  }

  Future<void> _loadLists() async {
    final loadedLists = await widget.genreRepository.getAllGenres();
    setState(() {
      myLists = loadedLists;
    });
  }

  @override
  void dispose() {
    // ウィジェットが破棄されるときにコントローラーをクリーンアップ
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _updateState() {
    setState(() {
      // setState内で何もしなくても、_titleController.textの状態が変わるたびに
      // buildメソッドが再実行され、UIが更新される
    });
  }

  void addAciton(task) async {
    await widget.taskRepository.addTask(task);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      navigationBar: CupertinoNavigationBar(
        middle: const Text("New task"),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('Cancel'),
          onPressed: () {
            if (isDateSelected ||
                isTimeSelected ||
                isStarSelected ||
                _titleController.text.isNotEmpty ||
                _notesController.text.isNotEmpty) {
              showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) => CupertinoActionSheet(
                  actions: <CupertinoActionSheetAction>[
                    CupertinoActionSheetAction(
                      child: const Text('Discard Changes',
                          style: TextStyle(color: CupertinoColors.systemRed)),
                      onPressed: () {
                        // アクションシートを閉じる
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    isDefaultAction: true,
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context), // アクションシートを閉じる
                  ),
                ),
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
        trailing: CupertinoButton(
          onPressed: _titleController.text.isNotEmpty
              ? () => addAciton(Task(
                    title: _titleController.text,
                    notes: _notesController.text,
                    date: isDateSelected ? selectedDate : null,
                    time: isTimeSelected ? selectedTime : null,
                    star: isStarSelected,
                    genreId: widget.selectedMyList.id,
                    isCompleted: false,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  ))
              : null,
          padding: EdgeInsets.zero,
          child: Text(
            'Add',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              // テキストが空の場合は色を薄くする
              color: _titleController.text.isNotEmpty
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
            _buildTitleField(),
            _buildSelectDateTimeField(),
            _buildSelectListField(),
            _buildFlagSwitchField(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: CupertinoColors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoTextField(
            decoration: const BoxDecoration(),
            padding: const EdgeInsets.all(14.0),
            autofocus: true,
            controller: _titleController,
            clearButtonMode: OverlayVisibilityMode.editing,
            placeholder: 'Title',
            placeholderStyle: const TextStyle(
              color: CupertinoColors.systemGrey2,
            ),
          ),
          CupertinoTextField(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: CupertinoColors.systemGrey4,
                  width: 0.5,
                ),
              ),
            ),
            padding: const EdgeInsets.all(14.0),
            autofocus: true,
            controller: _notesController,
            clearButtonMode: OverlayVisibilityMode.editing,
            placeholder: 'Notes\n\n\n',
            placeholderStyle:
                const TextStyle(color: CupertinoColors.systemGrey2),
            maxLines: null,
            minLines: 4,
            keyboardType: TextInputType.multiline,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectDateTimeField() {
    return CupertinoPageScaffold(
      child: CupertinoListSection.insetGrouped(
          margin: const EdgeInsets.all(20),
          backgroundColor: CupertinoColors.extraLightBackgroundGray,
          children: [
            CupertinoListTile(
              backgroundColor: CupertinoColors.white,
              title: const Text("Date"),
              subtitle: isDateSelected
                  ? Text(
                      DateFormat('yyyy/MM/dd').format(selectedDate),
                      style: const TextStyle(color: CupertinoColors.activeBlue),
                    )
                  : null,
              trailing: CupertinoSwitch(
                value: isDateSelected,
                onChanged: (bool value) {
                  setState(() {
                    isDateSelected = value;
                  });
                  if (value) {
                    showDataPicker();
                  }
                  // スイッチの状態が変わったときの処理をここに記述
                },
              ),
              leading: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemRed,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child: Icon(CupertinoIcons.calendar,
                      color: CupertinoColors.white, size: 20),
                ),
              ),
              onTap: () {
                if (isDateSelected) {
                  showDataPicker();
                } else {
                  null;
                }
              }, // 何もしない場合はこのように記述
            ),
            CupertinoListTile(
              backgroundColor: CupertinoColors.white,
              title: const Text("Time"),
              subtitle: isTimeSelected
                  ? Text(
                      DateFormat('hh:mm').format(selectedTime),
                      style: const TextStyle(color: CupertinoColors.activeBlue),
                    )
                  : null,
              // スイッチを配置する例
              trailing: CupertinoSwitch(
                value: isTimeSelected, // ここにはスイッチの状態を制御する変数を使用
                onChanged: (bool value) {
                  setState(() {
                    isTimeSelected = value;
                  });
                  if (value) {
                    showTimePicker();
                  }
                  // スイッチの状態が変わったときの処理をここに記述
                },
              ),
              leading: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBlue,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child: Icon(CupertinoIcons.time_solid,
                      color: CupertinoColors.white, size: 20),
                ),
              ),
              onTap: () {
                if (isTimeSelected) {
                  showTimePicker();
                } else {
                  null;
                }
              }, // 何もしない場合はこのように記述
            )
          ]),
    );
  }

  Widget _buildSelectListField() {
    return CupertinoPageScaffold(
      child: CupertinoListSection.insetGrouped(
          margin: const EdgeInsets.only(left: 20, right: 20),
          backgroundColor: CupertinoColors.extraLightBackgroundGray,
          children: [
            CupertinoListTile(
              backgroundColor: CupertinoColors.white,
              title: const Text("List"),
              trailing: const CupertinoListTileChevron(),
              additionalInfo: Text(widget.selectedMyList.title),
              leading: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Color(widget.selectedMyList.color),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Icon(
                      IconUtils.getIconFromCodePoint(
                          widget.selectedMyList.icon),
                      color: CupertinoColors.white,
                      size: 20),
                ),
              ),
              onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => SelectListPage(
                      myList: myLists,
                      onSelected: widget.selectedMyList,
                      setSelected: (selectedGenre) {
                        setState(() {
                          widget.selectedMyList = selectedGenre;
                        });
                      },
                    ),
                  )),
            ),
          ]),
    );
  }

  Widget _buildFlagSwitchField() {
    return CupertinoPageScaffold(
      child: CupertinoListSection.insetGrouped(children: [
        CupertinoListTile(
          backgroundColor: CupertinoColors.white,
          title: const Text("Star"),
          leading: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: CupertinoColors.systemYellow,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Icon(CupertinoIcons.star_fill,
                  color: CupertinoColors.white, size: 20),
            ),
          ),
          trailing: CupertinoSwitch(
            value: isStarSelected,
            onChanged: (bool value) {
              setState(() {
                isStarSelected = value;
              });
            },
          ),
        ),
      ]),
    );
  }

  void showDataPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 216,
        color: CupertinoColors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // ボタン間のスペースを最大にして、両端に配置
              children: [
                CupertinoButton(
                  child: const Text('Cancel'),
                  onPressed: () => {
                    setState(() {
                      isDateSelected = false;
                    }),
                    Navigator.of(context).pop()
                  }, // Cancelボタンの処理
                ),
                CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () => Navigator.of(context).pop(), // Doneボタンの処理
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() {
                    selectedDate = newDateTime;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showTimePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 216,
        color: CupertinoColors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // ボタン間のスペースを最大にして、両端に配置
              children: [
                CupertinoButton(
                  child: const Text('Cancel'),
                  onPressed: () => {
                    setState(() {
                      isTimeSelected = false;
                    }),
                    Navigator.of(context).pop()
                  }, // Cancelボタンの処理
                ),
                CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () => {Navigator.of(context).pop()}, // Doneボタンの処理
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: DateTime.now(),
                use24hFormat: true,
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() {
                    selectedTime = newDateTime;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
