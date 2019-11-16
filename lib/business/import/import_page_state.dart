import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:jf_reader/tools/file_parser.dart';
import 'package:jf_reader/base/base.dart';

class ImportPageState with ChangeNotifier {
  String currentContent;
  loadFromUrl(String url) {
    DownloadManager.instance.loadFromUrl(url);
  }
}
