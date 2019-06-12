import 'dart:convert';
import 'package:meta/meta.dart';

class Material {
  Material(
      {@required this.name,
        @required this.id,
        @required this.phone});

  final String name;
  final String phone;
  final String id;

  static List<Material> allFromResponse(String response) {
    var decodedJson = json.decode(response).cast<String, dynamic>();

    return decodedJson['list']
        .cast<Map<String, dynamic>>()
        .map((obj) => Material.fromMap(obj))
        .toList()
        .cast<Material>();
  }

  static Material fromMap(Map map) {
    return new Material(
        name: map['name'],
        phone: map['phone'],
        id:map['id']);
  }
}
