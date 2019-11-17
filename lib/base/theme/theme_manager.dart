import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import './theme_model.dart';
const THEME_KEY = 'ThemeManager';
class ThemeManager with ChangeNotifier{
  factory ThemeManager() => _getInstance();
  static ThemeManager get instance => _getInstance();
  static ThemeManager _instance;
  ThemeManager._internal() {
    // 初始化
  }
  static ThemeManager _getInstance() {
    if (_instance == null) {
      _instance = new ThemeManager._internal();
    }
    return _instance;
  }

  SharedPreferences _prefs;
  ThemeModel model;
  loadData() async {
    _prefs = await SharedPreferences.getInstance();
    var themeStr = _prefs.getString(THEME_KEY);
    if (themeStr != null && themeStr.length > 0) {
      Map decoded = jsonDecode(themeStr);
      model = ThemeModel.fromJson(decoded);
    }
    notifyListeners();
  }
}
