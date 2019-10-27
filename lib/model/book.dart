import 'package:json_annotation/json_annotation.dart';
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
}
@JsonSerializable()
class  ChapterModel {
  ChapterModel();
  String bookID;
  String name;
  String chapterID;
  factory ChapterModel.fromJson(Map<String, dynamic> json) => _$ChapterModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChapterModelToJson(this);
}