import 'coupon_description.dart';

class CouponResponse{
  String msg;
  int code;
  bool state;
  List<CouponDescription> couponList;

  CouponResponse({this.msg, this.code, this.state, this.couponList});

  CouponResponse.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    code = json['code'];
    state = json['state'];
    if (json['list'] != null) {
      couponList = new List<CouponDescription>();
      json['list'].forEach((v) {
        couponList.add(new CouponDescription.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    data['state'] = this.state;
    if (this.couponList != null) {
      data['list'] = this.couponList.map((v) => v.toJson()).toList();
    }
    return data;
  }


}