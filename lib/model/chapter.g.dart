// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChapterModel _$ChapterModelFromJson(Map<String, dynamic> json) {
  return ChapterModel()
    ..bookID = json['bookID'] as String
    ..name = json['name'] as String
    ..chapterID = json['chapterID'] as String;
}

Map<String, dynamic> _$ChapterModelToJson(ChapterModel instance) =>
    <String, dynamic>{
      'bookID': instance.bookID,
      'name': instance.name,
      'chapterID': instance.chapterID,
    };
