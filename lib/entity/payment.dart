import 'dart:convert';

class Payment {
  Payment(
      {this.appid,
      this.sign,
      this.partnerid,
      this.prepayid,
      this.timestamp,
      this.key,
      this.noncestr,
      this.package});

  final String appid;
  final String sign;
  final String partnerid;
  final String prepayid;
  final String timestamp;
  final String package;
  final String key;
  final String noncestr;

  static Payment allFromResponse(String response) {
    Payment description = Payment.fromMap(json.decode(response)['data']);
    return description;
  }

  static Payment fromMap(dynamic map) {
    return new Payment(
        appid: map['appid'],
        sign: map['sign'],
        partnerid: map['partnerid'],
        prepayid: map['prepayid'],
        timestamp: map['timestamp'],
        package: map['package'],
        key: map['key'],
        noncestr: map['noncestr']);
  }
}
