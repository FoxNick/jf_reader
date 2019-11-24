import 'package:json_annotation/json_annotation.dart';
import './chapter_content_manager.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui show window;
part 'chapter.g.dart';

class ContentOffset {
  int start;
  int end;
}

@JsonSerializable()
class ChapterModel {
  ChapterModel();
  String bookID;
  String name;
  String chapterID;
  String chapterUrl;

  factory ChapterModel.fromJson(Map<String, dynamic> json) =>
      _$ChapterModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChapterModelToJson(this);

  getContent() async {
    return ChapterContentManager.instance.readChapterContent(bookID, chapterID);
  }

  saveContent(String content) {
    ChapterContentManager.instance
        .saveChapterContent(bookID, chapterID, content);
  }

  List<ContentOffset> getPageOffsets(
      String content, double height, double width, double fontSize) {
    String tempStr = content;
    List<ContentOffset> pageConfig = [];
    int last = 0;
    while (true) {
      ContentOffset offset = ContentOffset();
      offset.start = last;
      TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
      textPainter.text =
          TextSpan(text: tempStr, style: TextStyle(fontSize: fontSize));
      textPainter.layout(maxWidth: width);
      var end = textPainter.getPositionForOffset(Offset(width, height)).offset;

      if (end == 0) {
        break;
      }
      tempStr = tempStr.substring(end, tempStr.length);
      offset.end = last + end;
      last = last + end;
      pageConfig.add(offset);
    }
    return pageConfig;
  }
}
