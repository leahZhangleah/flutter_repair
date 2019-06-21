class RepairsServiceResponse{
  String msg;
  int code;
  bool state;
  RepairsServiceCharge repairsServiceCharge;

  RepairsServiceResponse({this.msg, this.code, this.state, this.repairsServiceCharge});

  RepairsServiceResponse.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    code = json['code'];
    state = json['state'];
    repairsServiceCharge = json['repairsServiceCharge'] != null
        ? new RepairsServiceCharge.fromJson(json['repairsServiceCharge'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    data['state'] = this.state;
    if (this.repairsServiceCharge != null) {
      data['repairsServiceCharge'] = this.repairsServiceCharge.toJson();
    }
    return data;
  }
}

class RepairsServiceCharge {
  String id;
  String serviceCharge;
  int isclose;
  int subscriptionRate;
  String createUser;
  String createTime;
  String updateTime;

  RepairsServiceCharge(
      {this.id,
        this.serviceCharge,
        this.isclose,
        this.subscriptionRate,
        this.createUser,
        this.createTime,
        this.updateTime});

  RepairsServiceCharge.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceCharge = json['serviceCharge'];
    isclose = json['isclose'];
    subscriptionRate = json['subscriptionRate'];
    createUser = json['createUser'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['serviceCharge'] = this.serviceCharge;
    data['isclose'] = this.isclose;
    data['subscriptionRate'] = this.subscriptionRate;
    data['createUser'] = this.createUser;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    return data;
  }
}