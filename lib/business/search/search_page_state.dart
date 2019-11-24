import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:fast_gbk/fast_gbk.dart';
import 'package:jf_reader/tools/decoder.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:jf_reader/base/base.dart';

class SearchResultModel {
  String name = '';
  String latest = '';
  String author = '';
  String catalogUrl = '';
  String coverUrl = '';
  String rootUrl = '';
  String configKey = '';
  bool isLoading = false;
  String get bookID {
    return '${catalogUrl.hashCode}';
  }

  SearchResultModel();
  factory SearchResultModel.fromJson(Map<String, dynamic> json) =>
      SearchResultModel()
        ..name = json["name"] ?? ''
        ..latest = json["latest"] ?? ''
        ..author = json["author"] ?? ''
        ..catalogUrl = json["catalogUrl"] ?? ''
        ..coverUrl = json['coverUrl'] ?? ''
        ..rootUrl = json['rootUrl'] ?? ''
        ..configKey = json["configKey"] ?? '';
}

class SearchPageState with ChangeNotifier {
  String searchContent = "";
  Map<String, List<SearchResultModel>> resultModelsMap = {};
  TextEditingController textController;
  // 配置
  SearchPageState(this.searchContent) {
    textController = TextEditingController(text: searchContent);
    if (searchContent != null && searchContent.length > 0) {
      searchCurrentKeyword();
    }
  }

  searchCurrentKeyword() {
    resultModelsMap = Map();
    ConfigManager().spiderConfig.forEach((key, value) async {
      List<Map> result = await Spider.search(searchContent, key);
      List<SearchResultModel> models = List<SearchResultModel>();
      for (Map map in result) {
        SearchResultModel model = SearchResultModel.fromJson(map);
        models.add(model);
      }
      resultModelsMap[key] = models;
      notifyListeners();
    });
  }

  addBook(SearchResultModel searchModel) async {
    searchModel.isLoading = true;
    notifyListeners();
    Book book = Book()
      ..bookType = BookType.NetworkBook
      ..bookName = searchModel.name
      ..bookID = searchModel.bookID
      ..cover = searchModel.coverUrl
      ..configKey = searchModel.configKey
      ..chaptersURL = searchModel.catalogUrl;
    await BookShelfManager().updateChaptersAndAddBook(book);
    searchModel.isLoading = false;
    notifyListeners();
  }
}
