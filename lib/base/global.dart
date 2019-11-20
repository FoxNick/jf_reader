import 'dart:ui';
import 'package:flutter/cupertino.dart';

class Global {
  Global();
  static Color scaffoldBackgroundColor = Color(0xFFE5E5EA);
  static Color subtitleGrayColor = Color.fromARGB(255, 153, 153, 155);
  static Color grayMaskColor = Color(0x22000000);
  static Color translucentColor = Color(0x00000000);

  // 排行榜页面
  static TextStyle rankPageTipTextStyle =
      TextStyle(fontSize: 12, color: Global.subtitleGrayColor);
  static TextStyle rankCategoryTextStyle =
      TextStyle(fontSize: 14, color: Global.subtitleGrayColor);
  static TextStyle rankCategorySelectedTextStyle =
      TextStyle(fontSize: 14, color: CupertinoColors.activeBlue);

  // 搜索页
  static Color searchPageBackgroundColor = Color.fromARGB(255, 94, 145, 247);
  static Color searchPageTextFieldBGColor = Color.fromARGB(255, 40, 95, 246);
  static Color searchPageTextFieldPlaceholderColor =
      Color.fromARGB(255, 130, 169, 249);
  static TextStyle searchCancelTextStyle =
      TextStyle(fontSize: 18, color: CupertinoColors.white);
  static TextStyle searchPageTextFieldTextStyle =
      TextStyle(fontSize: 16, color: CupertinoColors.white);
}
