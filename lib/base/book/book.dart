import 'package:json_annotation/json_annotation.dart';
import '../chapter/chapter.dart';
part 'book.g.dart';

@JsonSerializable()
class Book {
  Book();
  // 公共
  BookType bookType = BookType.LocalBook;
  String bookName;
  String bookID;
  String cover;
  String latestChapterID;
  String latestChapterName;
  String _currentChapterID;
  String _currentChapterName;
  List<ChapterModel> chapters = List<ChapterModel>();

  // 网络小说
  String configKey; //跟config里的key对应
  String chaptersURL; //章节列表页

  set currentChapterID(currentChapterID) {
    _currentChapterID = currentChapterID;
  }

  String get currentChapterID {
    if (_currentChapterID == null && chapters != null && chapters.length > 0) {
      return chapters.first.chapterID;
    }
    return _currentChapterID;
  }

  set currentChapterName(currentChapterName) {
    _currentChapterName = currentChapterName;
  }

  String get currentChapterName {
    if (_currentChapterName == null &&
        chapters != null &&
        chapters.length > 0) {
      return chapters.first.name;
    }
    return _currentChapterName;
  }

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
  Map<String, dynamic> toJson() => _$BookToJson(this);

  getChapter(String chapterID) {
    if (chapters == null) {
      return null;
    }
    int idx = chapters
        .indexWhere((ChapterModel chapter) => chapter.chapterID == chapterID);
    if (idx >= 0) {
      return chapters[idx];
    }
    return null;
  }

  nextChapter(String currentChapterID) {
    int idx = chapters.indexWhere(
        (ChapterModel chapter) => chapter.chapterID == currentChapterID);
    if (idx >= 0 && idx + 1 <= chapters.length - 1) {
      return chapters[idx + 1];
    }
    return null;
  }

  previousChapter(String currentChapterID) {
    int idx = chapters.indexWhere(
        (ChapterModel chapter) => chapter.chapterID == currentChapterID);
    if (idx >= 1) {
      return chapters[idx - 1];
    }
    return null;
  }
}

enum BookType { LocalBook, NetworkBook }
