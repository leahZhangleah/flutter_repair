import 'package:repair_project/ui/order/order_detail_bean/orders.dart';

class OrderDetailResponse{
  String msg;
  int code;
  String fileUploadServer;
  Orders orders;
  bool state;

  OrderDetailResponse(
      {this.msg, this.code, this.fileUploadServer, this.orders, this.state});

  OrderDetailResponse.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    code = json['code'];
    fileUploadServer = json['fileUploadServer'];
    orders =
    json['orders'] != null ? new Orders.fromJson(json['orders']) : null;
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    data['fileUploadServer'] = this.fileUploadServer;
    if (this.orders != null) {
      data['orders'] = this.orders.toJson();
    }
    data['state'] = this.state;
    return data;
  }
}