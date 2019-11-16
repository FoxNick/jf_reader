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
    ..latestChapterID = json['latestChapterID'] as String
    ..latestChapterName = json['latestChapterName'] as String
    ..currentChapterID = json['currentChapterID'] as String
    ..currentChapterName = json['currentChapterName'] as String
    ..chapters = (json['chapters'] as List)
        ?.map((e) =>
            e == null ? null : ChapterModel.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
      'bookName': instance.bookName,
      'url': instance.url,
      'bookID': instance.bookID,
      'cover': instance.cover,
      'latestChapterID': instance.latestChapterID,
      'latestChapterName': instance.latestChapterName,
      'currentChapterID': instance.currentChapterID,
      'currentChapterName': instance.currentChapterName,
      'chapters': instance.chapters,
    };
