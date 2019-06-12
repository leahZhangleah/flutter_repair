class CouponDescription{
  String id;
  String couponId;
  String title;
  String repairsUserId;
  String phone;
  String name;
  String withAmount;
  String usedAmount;
  int status;
  String validStartTime;
  String validEndTime;
  String getTime;

  CouponDescription(
      {this.id,
        this.couponId,
        this.title,
        this.repairsUserId,
        this.phone,
        this.name,
        this.withAmount,
        this.usedAmount,
        this.status,
        this.validStartTime,
        this.validEndTime,
        this.getTime});

  CouponDescription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    couponId = json['couponId'];
    title = json['title'];
    repairsUserId = json['repairsUserId'];
    phone = json['phone'];
    name = json['name'];
    withAmount = json['with_amount'];
    usedAmount = json['used_amount'];
    status = json['status'];
    validStartTime = json['validStartTime'];
    validEndTime = json['validEndTime'];
    getTime = json['getTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['couponId'] = this.couponId;
    data['title'] = this.title;
    data['repairsUserId'] = this.repairsUserId;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['with_amount'] = this.withAmount;
    data['used_amount'] = this.usedAmount;
    data['status'] = this.status;
    data['validStartTime'] = this.validStartTime;
    data['validEndTime'] = this.validEndTime;
    data['getTime'] = this.getTime;
    return data;
  }


}