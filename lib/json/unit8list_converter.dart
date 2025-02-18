import 'dart:typed_data';
import 'package:json_annotation/json_annotation.dart';

class Uint8ListConverter implements JsonConverter<Uint8List, String> {
  const Uint8ListConverter();

  @override
  Uint8List fromJson(String json) {
    List<int> list = json.codeUnits;
    return Uint8List.fromList(list);
  }

  @override
  String toJson(Uint8List object) => String.fromCharCodes(object);
}
