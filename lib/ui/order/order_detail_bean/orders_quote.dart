import 'package:repair_project/ui/order/order_detail_bean/maintainer_user.dart';

class OrdersQuote {
  String id;
  String repairsOrdersId;
  String maintainerUserId;
  int quoteMoney;
  int subscriptionRate;
  int subscriptionMoney;
  int balanceMoney;
  String createTime;
  String updateTime;
  int status;
  MaintainerUser maintainerUser;

  OrdersQuote(
      {this.id,
        this.repairsOrdersId,
        this.maintainerUserId,
        this.quoteMoney,
        this.subscriptionRate,
        this.subscriptionMoney,
        this.balanceMoney,
        this.createTime,
        this.updateTime,
        this.status,
        this.maintainerUser});

  OrdersQuote.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    repairsOrdersId = json['repairsOrdersId'];
    maintainerUserId = json['maintainerUserId'];
    quoteMoney = json['quoteMoney'];
    subscriptionRate = json['subscriptionRate'];
    subscriptionMoney = json['subscriptionMoney'];
    balanceMoney = json['balanceMoney'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    status = json['status'];
    maintainerUser = json['maintainerUser'] != null
        ? new MaintainerUser.fromJson(json['maintainerUser'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['repairsOrdersId'] = this.repairsOrdersId;
    data['maintainerUserId'] = this.maintainerUserId;
    data['quoteMoney'] = this.quoteMoney;
    data['subscriptionRate'] = this.subscriptionRate;
    data['subscriptionMoney'] = this.subscriptionMoney;
    data['balanceMoney'] = this.balanceMoney;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['status'] = this.status;
    if (this.maintainerUser != null) {
      data['maintainerUser'] = this.maintainerUser.toJson();
    }
    return data;
  }
}