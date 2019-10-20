// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json) {
  return Book()
    ..bookName = json['bookName'] as String
    ..url = json['url'] as String
    ..bookID = json['bookID'] as String
    ..cover = json['cover'] as String
    ..latestChapter = json['latestChapter'] as int
    ..latestChapterName = json['latestChapterName'] as String
    ..currentChapter = json['currentChapter'] as int
    ..currentChapterName = json['currentChapterName'] as String;
}

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
      'bookName': instance.bookName,
      'url': instance.url,
      'bookID': instance.bookID,
      'cover': instance.cover,
      'latestChapter': instance.latestChapter,
      'latestChapterName': instance.latestChapterName,
      'currentChapter': instance.currentChapter,
      'currentChapterName': instance.currentChapterName,
    };
