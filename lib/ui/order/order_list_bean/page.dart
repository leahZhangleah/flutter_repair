import 'package:repair_project/ui/order/order_detail_bean/orders.dart';

class Page{
  int total;
  List<Orders> orders;

  Page({this.total, this.orders});

  Page.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['rows'] != null) {
      orders = new List<Orders>();
      json['rows'].forEach((v) {
        orders.add(new Orders.fromJson(v));
      });
    }else{
      orders = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    if (this.orders != null) {
      data['rows'] = this.orders.map((v) => v.toJson()).toList();
    }
    return data;
  }
}