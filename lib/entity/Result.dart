import 'User.dart';

class Result<T>{
//
//  {
//  "msg": "success",
//  "code": 0,
//  "state": true
//  }
  User datas;

  int code;
  String msg;


  Result({this.datas, this.code, this.msg});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      datas: User.fromJson(json['datas']),
      code: json['code'],
      msg: json['msg'],
    );
  }
}