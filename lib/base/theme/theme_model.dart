import 'dart:ui';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/cupertino.dart';
// import '../extension/color+json.dart';
part 'theme_model.g.dart';
@JsonSerializable(nullable: true, includeIfNull: false)
class ThemeModel {
  ThemeModel();
  // 全局UI
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color backgroundColor = CupertinoColors.lightBackgroundGray;

  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color cellBackgroundColor = CupertinoColors.lightBackgroundGray;

  
  factory ThemeModel.fromJson(Map<String, dynamic> json) => _$ThemeModelFromJson(json);
  Map<String, dynamic> toJson() => _$ThemeModelToJson(this);

}


Color _colorFromJson(String colorString) {
  int intColor = int.tryParse(colorString, radix: 16);
  if (intColor == null)
    return null;
  else
    return new Color(intColor);
}

String _colorToJson(Color color) => color.value.toRadixString(16);