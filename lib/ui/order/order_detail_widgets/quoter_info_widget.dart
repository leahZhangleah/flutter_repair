import 'package:flutter/material.dart';
import 'package:repair_project/ui/order/order_detail_bean/orders.dart';
import 'package:repair_project/ui/order/order_detail_bean/quote_user.dart';

class QuoterInfoWidget extends StatelessWidget{
  Orders orders;
  QuoterInfoWidget({this.orders});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    QuoteUser quoteUser = orders.quoteUser;
    return quoteUser!=null?
    Container(
      margin: EdgeInsets.only(top: 10),
      height: 75,
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("报价员： "+quoteUser.name),
          SizedBox(width: 20),
          Text("联系电话： "+quoteUser.phone),
          SizedBox(height: 10),
        ],
      ),
    ):Container();;
  }

}