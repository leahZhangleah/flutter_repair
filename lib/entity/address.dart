import 'dart:convert';
import 'package:meta/meta.dart';

class Address {
  Address(
      {@required this.name,
      @required this.id,
      @required this.phone,
      @required this.province,
      @required this.city,
      @required this.district,
      @required this.detailedAddress,
      @required this.defaultAddress});

  final String name;
  final String phone;
  final String province;
  final String city;
  final String district;
  final String detailedAddress;
  final String id;
  final int defaultAddress;

  static List<Address> allFromResponse(String response) {
    var decodedJson = json.decode(response).cast<String, dynamic>();

    return decodedJson['list']
        .cast<Map<String, dynamic>>()
        .map((obj) => Address.fromMap(obj))
        .toList()
        .cast<Address>();
  }

  static Address fromMap(Map map) {
    return new Address(
        name: map['name'],
        phone: map['phone'],
        province: map['province'],
        city: map['city'],
        district: map['district'],
        id:map['id'],
        detailedAddress: map['detailedAddress'],
    defaultAddress: map['defaultAddress']);
  }
}
