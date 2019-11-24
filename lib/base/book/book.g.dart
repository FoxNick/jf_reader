// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json) {
  return Book()
    ..bookType = _$enumDecodeNullable(_$BookTypeEnumMap, json['bookType'])
    ..bookName = json['bookName'] as String
    ..bookID = json['bookID'] as String
    ..cover = json['cover'] as String
    ..latestChapterID = json['latestChapterID'] as String
    ..latestChapterName = json['latestChapterName'] as String
    ..chapters = (json['chapters'] as List)
        ?.map((e) =>
            e == null ? null : ChapterModel.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..configKey = json['configKey'] as String
    ..chaptersURL = json['chaptersURL'] as String
    ..currentChapterID = json['currentChapterID'] as String
    ..currentChapterName = json['currentChapterName'] as String;
}

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
      'bookType': _$BookTypeEnumMap[instance.bookType],
      'bookName': instance.bookName,
      'bookID': instance.bookID,
      'cover': instance.cover,
      'latestChapterID': instance.latestChapterID,
      'latestChapterName': instance.latestChapterName,
      'chapters': instance.chapters,
      'configKey': instance.configKey,
      'chaptersURL': instance.chaptersURL,
      'currentChapterID': instance.currentChapterID,
      'currentChapterName': instance.currentChapterName,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$BookTypeEnumMap = {
  BookType.LocalBook: 'LocalBook',
  BookType.NetworkBook: 'NetworkBook',
};
