// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThemeModel _$ThemeModelFromJson(Map<String, dynamic> json) {
  return ThemeModel()
    ..backgroundColor = _colorFromJson(json['backgroundColor'] as String);
}

Map<String, dynamic> _$ThemeModelToJson(ThemeModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('backgroundColor', _colorToJson(instance.backgroundColor));
  return val;
}
