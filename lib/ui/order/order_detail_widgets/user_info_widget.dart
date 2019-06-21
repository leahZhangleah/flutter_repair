import 'package:flutter/material.dart';
import 'package:repair_project/ui/order/order_detail_bean/orders.dart';

class UserInfoWidget extends StatelessWidget{
  Orders orders;

  UserInfoWidget({this.orders});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("联系人： "+orders.contactsName),
          SizedBox(height: 10),
          Text("联系电话： "+orders.contactsPhone),
          SizedBox(height: 10),
          Text("联系地址： "+orders.contactsAddress),
          SizedBox(height: 10),
        ],
      ),
    );;
  }

}