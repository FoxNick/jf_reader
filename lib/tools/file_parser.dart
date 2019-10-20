import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';
import 'package:fast_gbk/fast_gbk.dart';
import 'dart:typed_data';
import 'dart:convert';
import '../model/book.dart';
class FileParser {

  static parseWithLocalFile (String filePath) async {
    final ByteData data = await rootBundle.load(filePath);
    String content = await compute(decodeLogic, data);
    var bookModel = await parseWithContent(content);
    return bookModel;
  }
  static parseWithContent (String content) async {
    List<ChapterModel> chapters = await compute(parseContentLogic, content);
    print('chapters count:${chapters.length}');
    return chapters;
  }
}

String utf8DecodeLogic(ByteData data){
  return utf8.decode(data.buffer.asUint8List());
}
String decodeLogic(ByteData data){
  List<Encoding> codecs = [utf8,gbk];
  for (var codec in codecs) {
    String content = decode(data,codec);
    if(content != null){
      return content;
    }
  }
  return null;
}
String decode(ByteData data,Encoding codec){
  try {
    return codec.decode(data.buffer.asUint8List());
  } catch (e) {
    return null;
  }
}

List<ChapterModel> parseContentLogic(String content) {
  RegExp reg = new RegExp(r"第[0-9一二三四五六七八九十百千]*[章回节].*");
  Iterable<Match> matches = reg.allMatches(content);
  var currentStart = 0;
  List<ChapterModel> chapters = [];
  String lastName;
  for (Match m in matches) {
    print(m.group(0));
    // 太长，应该是误判了
    if(m.group(0).length > 30){
      continue;
    }
    if ((lastName == null || lastName.length == 0) && currentStart == 0) {
      // 有前言
      if (m.start > currentStart) {
        String chapterContent = content.substring(currentStart,m.start);
        ChapterModel model = ChapterModel()
                              ..name = '前言'
                              ..content = chapterContent
                              ..index = chapters.length;
        chapters.add(model);
      } else {

      }
    }
    else{
      String chapterContent = content.substring(currentStart,m.start);
      ChapterModel model = ChapterModel()
                            ..name = lastName
                            ..content = chapterContent
                            ..index = chapters.length;
      chapters.add(model);
    }
    lastName = m.group(0);
    currentStart = m.start;
  }
  String chapterContent = content.substring(currentStart,content.length);
  ChapterModel lastModel = ChapterModel()
                        ..name = lastName
                        ..content = chapterContent
                        ..index = chapters.length;
  chapters.add(lastModel);
  return chapters;
}