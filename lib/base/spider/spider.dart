import '../config/config_manager.dart';
import 'package:dio/dio.dart';
import 'package:fast_gbk/fast_gbk.dart';
import 'package:jf_reader/tools/decoder.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'dart:convert';
import 'package:jf_reader/base/base.dart';

getStrWithElementAndConfig(Element element, Map config, String currentURL) {
  var ele = element.querySelector(config['selector']);
  if (ele == null) {
    return null;
  }
  var result = '';
  if (config['type'] == 'inner') {
    result = ele.text;
  } else if (config['type'] == 'attr') {
    var attrKey = config['attrKey'];
    result = ele.attributes[attrKey];
  }
  if (config['processResult'] != null) {
    String processResult = config['processResult'];
    processResult =
        processResult.replaceAll(RegExp('#currentURL#'), currentURL);
    processResult = processResult.replaceAll(RegExp('#result#'), result);
    result = processResult;
  }
  return result;
}

handleSearchResultParse(
    searchConfig, rootElement, currentURL, rootURL, configKey) {
  var resultElements =
      rootElement.querySelectorAll(searchConfig['resultElements']);
  Map elementParseConfig = searchConfig['elementParse'];
  List<Map> models = List<Map>();
  if (resultElements != null && resultElements.length > 0) {
    for (var resultElement in resultElements) {
      Map<String, dynamic> resultMap = {};
      elementParseConfig.forEach((key, value) {
        if (value is String) {
          value = value.replaceAll(RegExp('#currentURL#'), currentURL);
          resultMap[key] = value;
        } else {
          resultMap[key] =
              getStrWithElementAndConfig(resultElement, value, currentURL);
        }
      });
      resultMap['rootUrl'] = rootURL;
      resultMap['configKey'] = configKey;
      models.add(resultMap);
    }
  } else {
    Map notFountConfig = searchConfig['notFound'];
    if (notFountConfig != null) {
      models = handleSearchResultParse(
          notFountConfig, rootElement, currentURL, rootURL, configKey);
    }
  }
  return models;
}

class Spider {
  Spider();

  static Future<List<Map>> search(searchContent, configKey) async {
    Map config = ConfigManager().spiderConfig[configKey];
    if (config == null) {
      return null;
    }
    String rootURL = config['rootURL'] ?? "";
    Map searchConfig = config['search'] ?? {};
    String searchURL = searchConfig['url'] ?? "";
    String encodeType = searchConfig['encodeType'] ?? "utf8";
    Encoding codec = utf8;
    if (encodeType == 'gbk') {
      codec = gbk;
    }
    String encodedContent =
        Uri.encodeQueryComponent(searchContent, encoding: codec);
    searchURL = searchURL.replaceAll(RegExp('#bookname#'), encodedContent);
    String decodeType = searchConfig['decodeType'] ?? "utf8";
    Response rs = await Dio(BaseOptions(
            responseDecoder: decodeType == 'gbk' ? gbkResponseDecoder : null))
        .get(searchURL);
    var document = parse(rs.data);
    List<Map> models = handleSearchResultParse(
        searchConfig,
        document.documentElement,
        rs.isRedirect ? (rs.realUri.toString() ?? searchURL) : searchURL,
        rootURL,
        configKey);
    // var resultElements =
    //     document.querySelectorAll(searchConfig['resultElements']);
    // Map elementParseConfig = searchConfig['elementParse'];
    // if (resultElements != null && resultElements.length > 0) {
    //   for (var resultElement in resultElements) {
    //     Map<String, dynamic> resultMap = {};
    //     elementParseConfig.forEach((key, value) {
    //       resultMap[key] =
    //           getStrWithElementAndConfig(resultElement, value, searchURL);
    //     });
    //     SearchResultModel model = SearchResultModel.fromJson(resultMap);
    //     model.rootUrl = rootURL;
    //     model.configKey = configKey;
    //     models.add(model);
    //   }
    // } else {
    //   Map notFountConfig = searchConfig['notFound'];
    //   if (notFountConfig != null) {}
    // }
    print('search $searchContent in $configKey,result count:${models.length}');
    return models;
  }

  ///[{
  ///chapterName:
  ///chapterUrl:
  ///}]
  static Future<List<Map>> getChapters(configKey, chaptersURL) async {
    Map config = ConfigManager().spiderConfig[configKey];
    if (config == null) {
      return null;
    }
    Map catalogConfig = config['catalog'];
    String decodeType = catalogConfig['decodeType'] ?? "utf8";
    Response rs = await Dio(BaseOptions(
            responseDecoder: decodeType == 'gbk' ? gbkResponseDecoder : null))
        .get(chaptersURL);
    var document = parse(rs.data);
    var chapterElements =
        document.querySelectorAll(catalogConfig['chapterElements']);
    Map elementParseConfig = catalogConfig['elementParse'];
    List<Map> chapters = List();
    for (var chapterElement in chapterElements) {
      Map<String, dynamic> resultMap = {};
      elementParseConfig.forEach((key, value) {
        var result =
            getStrWithElementAndConfig(chapterElement, value, chaptersURL);
        if (result != null) {
          resultMap[key] = result;
        } else {
          print('$key not found');
          resultMap = null;
        }
      });
      if (resultMap != null) {
        chapters.add(resultMap);
      }
    }
    return chapters;
  }

  static Future<String> getChapterContent(bookID, chapterID) async {
    Book book = BookShelfManager().getBook(bookID);
    if (book == null) {
      print('no book $bookID');
      return null;
    }
    if (book.bookType != BookType.NetworkBook) {
      print('not network book $bookID');
      return null;
    }
    ChapterModel chapter = book.getChapter(chapterID);
    if (chapter == null) {
      print('no chapter:$bookID $chapterID');
      return null;
    }
    Map config = ConfigManager().spiderConfig[book.configKey];
    if (config == null) {
      print('no config:${book.configKey}');
      return null;
    }
    print('get chapterContent:${book.bookName} ${chapter.name}');
    String url = chapter.chapterUrl;
    if (url == null || url.length == 0) {
      return null;
    }
    Map chapterConfig = config['chapter'];
    String decodeType = chapterConfig['decodeType'] ?? "utf8";
    Response rs = await Dio(BaseOptions(
            connectTimeout: 5000,
            receiveTimeout: 5000,
            responseDecoder: decodeType == 'gbk' ? gbkResponseDecoder : null))
        .get(url);
    var document = parse(rs.data);
    String content = getStrWithElementAndConfig(
        document.documentElement, chapterConfig['contentElement'], url);
    return content;
  }
}
