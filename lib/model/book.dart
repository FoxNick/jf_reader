import 'package:json_annotation/json_annotation.dart';
import './chapter.dart';
part 'book.g.dart';
@JsonSerializable()
class Book {
  Book();
  String bookName;
  String url;
  String bookID;
  String cover;
  String latestChapterID;
  String latestChapterName;
  String currentChapterID;
  String currentChapterName;
  List<ChapterModel> chapters;
  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
  Map<String, dynamic> toJson() => _$BookToJson(this);

  getChapter(String chapterID){
    int idx = chapters.indexWhere((ChapterModel chapter) => chapter.chapterID == chapterID);
    if (idx >= 0) {
      return chapters[idx];
    }
    return null;
  }
  nextChapter(String currentChapterID){
    int idx = chapters.indexWhere((ChapterModel chapter) => chapter.chapterID == currentChapterID);
    if (idx >= 0 && idx + 1 <= chapters.length - 1) {
      return chapters[idx + 1];
    }
    return null;
  }
  previousChapter(String currentChapterID){
    int idx = chapters.indexWhere((ChapterModel chapter) => chapter.chapterID == currentChapterID);
    if (idx >= 1) {
      return chapters[idx - 1];
    }
    return null;
  }
}