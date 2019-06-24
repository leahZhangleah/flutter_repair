import 'package:flutter/material.dart';
import 'package:repair_project/ui/order/order_detail_bean/orders.dart';
import 'package:repair_project/ui/order/order_detail_bean/orders_appraise.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class OrderDetailFeedbackWidget extends StatelessWidget{
  Orders orders;

  OrderDetailFeedbackWidget({this.orders});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    OrdersAppraise ordersAppraise = orders.ordersAppraise;
    return ordersAppraise!=null?
    Container(
      padding: EdgeInsets.all(10),
      color: Colors.white,
      margin: EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("创建时间：",style: TextStyle(color: Colors.grey)),
              Text(ordersAppraise.createTime,style: TextStyle(color: Colors.grey),),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("是否解决：",style: TextStyle(color: Colors.grey)),
              ordersAppraise.isSolve==1?
              Text("已解决",style: TextStyle(color: Colors.grey),):
              Text("未解决",style: TextStyle(color: Colors.grey),),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("满意度：",style: TextStyle(color: Colors.grey)),
              SmoothStarRating(
                allowHalfRating: false,
                starCount: 5,
                rating: double.tryParse(ordersAppraise.starLevel.toString()),
                size: 20.0,
                color: Colors.lightBlue,
                borderColor: Colors.grey[350],
              )
            ],
          ),
          Text(
              ordersAppraise.content
          ),
        ],
      ),
    ):Container();
  }

}