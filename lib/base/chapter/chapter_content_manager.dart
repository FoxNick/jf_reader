import 'package:jf_reader/base/spider/spider.dart';
import 'package:quiver/cache.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

class ChapterContentManager with ChangeNotifier {
  // 工厂模式
  factory ChapterContentManager() => _getInstance();
  static ChapterContentManager get instance => _getInstance();
  static ChapterContentManager _instance;

  ChapterContentManager._internal() {
    // 初始化
  }
  static ChapterContentManager _getInstance() {
    if (_instance == null) {
      _instance = new ChapterContentManager._internal();
    }
    return _instance;
  }

  // <bookid_chapter_id,content>
  MapCache<String, String> chaptersCache = MapCache.lru(maximumSize: 50);
  saveChapterContent(String bookID, String chapterID, String content) {
    chaptersCache.set("$bookID\_$chapterID", content);
    () async {
      await checkBookDir(bookID);
      String dir = (await getApplicationDocumentsDirectory()).path;
      File chapterFile = new File('$dir/$bookID/$chapterID');
      File result = await chapterFile.writeAsString(content);
      print(result);
    }();
  }

  checkBookDir(String bookID) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    String bookDir = '$dir/$bookID';
    Directory directory = Directory(bookDir);
    bool isExist = await directory.exists();
    if (!isExist) {
      await directory.create();
    }
  }

  readChapterContent(String bookID, String chapterID) async {
    String content =
        await chaptersCache.get("$bookID\_$chapterID", ifAbsent: (key) async {
      String dir = (await getApplicationDocumentsDirectory()).path;
      try {
        File chapterFile = new File('$dir/$bookID/$chapterID');
        String contents = await chapterFile.readAsString();
        return contents;
      } catch (e) {
        return '';
      }
    });
    if (content == null || content.length == 0) {
      content = await Spider.getChapterContent(bookID, chapterID);
    }
    return content;
  }
}
