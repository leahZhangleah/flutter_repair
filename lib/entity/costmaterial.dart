import 'dart:convert';
import 'package:meta/meta.dart';

class MaterialInfo {
  MaterialInfo(
      {@required this.name,
        @required this.id,
        @required this.description,
        @required this.unitPrice,
        @required this.picture});

  final String name;
  final String id;
  final String description;
  final String unitPrice;
  final String picture;

  static List<MaterialInfo> allFromResponse(String response) {
    var decodedJson = json.decode(response).cast<String, dynamic>();

    return decodedJson['page']['list']
        .cast<Map<String, dynamic>>()
        .map((obj) => MaterialInfo.fromMap(obj))
        .toList()
        .cast<MaterialInfo>();
  }

  static MaterialInfo fromMap(Map map) {
    return new MaterialInfo(
        name: map['name'],
        id: map['id'],
        description: map['description'],
        unitPrice: map['unitPrice'],
        picture: map['picture']);

  }
}
