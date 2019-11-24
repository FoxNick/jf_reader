import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class ConfigManager {
  factory ConfigManager() => _getInstance();
  static ConfigManager get instance => _getInstance();
  static ConfigManager _instance;

  // 配置
  Map spiderConfig = {};

  ConfigManager._internal() {
    // 初始化
    loadConfig();
  }
  static ConfigManager _getInstance() {
    if (_instance == null) {
      _instance = new ConfigManager._internal();
    }
    return _instance;
  }

  loadConfig() async {
    // TODO: load config from server
    // load local default config
    String data = await rootBundle.loadString("res/config/SpiderConfig.json");
    final jsonResult = json.decode(data);
    spiderConfig = jsonResult;
  }
}
