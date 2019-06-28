import 'package:repair_project/ui/order/order_detail_bean/maintainer_description_list.dart';
import 'package:repair_project/ui/order/order_detail_bean/maintainer_user.dart';
import 'package:repair_project/ui/order/order_detail_bean/orders_appraise.dart';
import 'package:repair_project/ui/order/order_detail_bean/orders_description_list.dart';
import 'package:repair_project/ui/order/order_detail_bean/orders_quote.dart';
import 'package:repair_project/ui/order/order_detail_bean/quote_user.dart';
import 'package:repair_project/ui/order/order_detail_bean/repairs_user.dart';

class Orders{
  String id;
  String orderNumber;
  String description;
  String type;
  int orderState;
  String contactsName;
  String contactsPhone;
  String contactsAddress;
  String createUserId;
  String createTime;
  String updateTime;
  int status;
  List<OrdersDescriptionList> ordersDescriptionList;
  RepairsUser repairsUser;
  QuoteUser quoteUser;
  OrdersQuote ordersQuote;
  MaintainerUser maintainerUser;
  List<MaintainerDescriptionList> maintainerDescriptionList;
  OrdersAppraise ordersAppraise;

  Orders(
      {this.id,
        this.orderNumber,
        this.description,
        this.type,
        this.orderState,
        this.contactsName,
        this.contactsPhone,
        this.contactsAddress,
        this.createUserId,
        this.createTime,
        this.updateTime,
        this.status,
        this.ordersDescriptionList,
        this.repairsUser,
        this.quoteUser,
        this.ordersQuote,
        this.maintainerUser,
        this.maintainerDescriptionList,
        this.ordersAppraise,});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNumber = json['orderNumber'];
    description = json['description'];
    type = json['type'];
    orderState = json['orderState'];
    contactsName = json['contactsName'];
    contactsPhone = json['contactsPhone'];
    contactsAddress = json['contactsAddress'];
    createUserId = json['createUserId'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    status = json['status'];
    if (json['ordersDescriptionList'] != null) {
      ordersDescriptionList = new List<OrdersDescriptionList>();
      json['ordersDescriptionList'].forEach((v) {
        ordersDescriptionList.add(new OrdersDescriptionList.fromJson(v));
      });
    }else{
      ordersDescriptionList = [];
    }
    repairsUser = json['repairsUser'] != null
        ? new RepairsUser.fromJson(json['repairsUser'])
        : null;
    quoteUser = json['quoteUser']!=null
        ? new QuoteUser.fromJson(json['quoteUser'])
        :null;
    ordersQuote = json['ordersQuote']!=null
        ? new OrdersQuote.fromJson(json['ordersQuote'])
        :null;
    maintainerUser = json['maintainerUser']!=null
        ? new MaintainerUser.fromJson(json['maintainerUser'])
        :null;
    if(json['maintainerDescriptionList']!=null){
      maintainerDescriptionList = new List<MaintainerDescriptionList>();
      json['maintainerDescriptionList'].forEach((v){
        maintainerDescriptionList.add(new MaintainerDescriptionList.fromJson(v));
      });
    }else{
      maintainerDescriptionList = [];
    }
    ordersAppraise = json['ordersAppraise']!=null
        ? new OrdersAppraise.fromJson(json['ordersAppraise'])
        :null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderNumber'] = this.orderNumber;
    data['description'] = this.description;
    data['type'] = this.type;
    data['orderState'] = this.orderState;
    data['contactsName'] = this.contactsName;
    data['contactsPhone'] = this.contactsPhone;
    data['contactsAddress'] = this.contactsAddress;
    data['createUserId'] = this.createUserId;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['status'] = this.status;
    if (this.ordersDescriptionList != null) {
      data['ordersDescriptionList'] =
          this.ordersDescriptionList.map((v) => v.toJson()).toList();
    }
    if (this.repairsUser != null) {
      data['repairsUser'] = this.repairsUser.toJson();
    }
    if (this.quoteUser != null) {
      data['quoteUser'] = this.quoteUser.toJson();
    }
    if (this.ordersQuote != null) {
      data['ordersQuote'] = this.ordersQuote.toJson();
    }
    if (this.maintainerUser != null) {
      data['maintainerUser'] = this.maintainerUser.toJson();
    }
    if (this.maintainerDescriptionList != null) {
      data['maintainerDescriptionList'] =
          this.maintainerDescriptionList.map((v) => v.toJson()).toList();
    }
    if (this.ordersAppraise != null) {
      data['ordersAppraise'] = this.ordersAppraise.toJson();
    }
    return data;
  }
}