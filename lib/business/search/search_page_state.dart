import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dio/dio.dart';
import 'package:fast_gbk/fast_gbk.dart';
import 'package:jf_reader/tools/decoder.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class SearchResultModel {
  String name = '';
  String latest = '';
  String author = '';
  String catalogUrl = '';
  SearchResultModel();
  factory SearchResultModel.fromJson(Map<String, dynamic> json) =>
      SearchResultModel()
        ..name = json["name"]
        ..latest = json["latest"]
        ..author = json["author"]
        ..catalogUrl = json["catalogUrl"];
}

class SearchPageState with ChangeNotifier {
  String searchContent = "";
  Map spiderConfig = {};
  SearchPageState() {
    loadConfig();
  }
  loadConfig() async {
    // TODO: load config from server
    // load local default config
    String data = await rootBundle.loadString("res/config/SpiderConfig.json");
    final jsonResult = json.decode(data);
    spiderConfig = jsonResult;
    if (searchContent.length > 0) {
      searchCurrentKeyword();
    }
    notifyListeners();
  }

  searchCurrentKeyword() {
    spiderConfig.forEach((key, value) {
      search(key, value, searchContent);
    });
  }

  search(key, config, searchContent) async {
    String rootURL = config['rootURL'] ?? "";
    Map searchConfig = config['search'] ?? {};
    String searchURL = searchConfig['url'] ?? "";
    String encodeType = searchConfig['encodeType'] ?? "utf8";
    Encoding codec = utf8;
    if (encodeType == 'gbk') {
      codec = gbk;
    }
    List<int> bookNameBytes = codec.encode(searchContent);
    String encodedContent =
        Uri.encodeQueryComponent(searchContent, encoding: codec);
    searchURL = searchURL.replaceAll(RegExp('#bookname#'), encodedContent);
    String decodeType = searchConfig['decodeType'] ?? "utf8";
    Response rs = await Dio(BaseOptions(
            responseDecoder: decodeType == 'gbk' ? gbkResponseDecoder : null))
        .get(searchURL);
    print(rs.data);
    List<SearchResultModel> resultModels = List<SearchResultModel>();
    var document = parse(rs.data);
    print(document.text);
    var resultElements =
        document.querySelectorAll(searchConfig['resultElements']);
    Map elementParseConfig = searchConfig['elementParse'];
    for (var resultElement in resultElements) {
      Map<String, dynamic> resultMap = {};
      elementParseConfig.forEach((key, value) {
        resultMap[key] = getStrWithElementAndConfig(resultElement, value);
      });
      SearchResultModel model = SearchResultModel.fromJson(resultMap);
      resultModels.add(model);
    }
  }

  getStrWithElementAndConfig(Element element, Map config) {
    var ele = element.querySelector(config['selector']);
    var result = '';
    if (config['type'] == 'inner') {
      result = ele.text;
    } else if (config['type'] == 'attr') {
      var attrKey = config['attrKey'];
      result = ele.attributes[attrKey];
    }
    return result;
  }
}
