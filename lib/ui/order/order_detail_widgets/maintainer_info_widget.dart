import 'package:flutter/material.dart';
import 'package:repair_project/ui/order/order_detail_bean/maintainer_user.dart';
import 'package:repair_project/ui/order/order_detail_bean/orders.dart';

class MaintainerInfoWidget extends StatelessWidget{
  Orders orders;

  MaintainerInfoWidget({this.orders});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    MaintainerUser maintainerUser = orders.maintainerUser;
    return maintainerUser!=null?
    Container(
      margin: EdgeInsets.only(top: 8.0),
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("维修员： "+maintainerUser.name),
          SizedBox(height: 10),
          Text("联系电话： "+maintainerUser.phone),
          SizedBox(height: 10),
        ],
      ),
    ):Container();
  }

}