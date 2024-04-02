import 'package:flutter/widgets.dart';

class IconUtils {
  static IconData getIconFromCodePoint(int codePoint) {
    return IconData(codePoint,
        fontFamily: 'CupertinoIcons', fontPackage: 'cupertino_icons');
  }
}
