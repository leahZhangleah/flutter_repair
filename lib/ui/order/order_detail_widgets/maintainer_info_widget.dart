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
      height: 75,
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("维修员： "+maintainerUser.name),
          SizedBox(width: 20),
          Text("联系电话： "+maintainerUser.phone),
          SizedBox(height: 10),
        ],
      ),
    ):Container();
  }

}