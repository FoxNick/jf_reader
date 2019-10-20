import 'package:json_annotation/json_annotation.dart';
part 'book.g.dart';
@JsonSerializable()
class Book {
  Book();
  String bookName;
  String url;
  String bookID;
  String cover;
  int latestChapter;
  String latestChapterName;
  int currentChapter;
  String currentChapterName;
  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
  Map<String, dynamic> toJson() => _$BookToJson(this);
}

class  ChapterModel {
  String bookID;
  String name;
  String content;
  int index;
}