import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repair_project/http/api_request.dart';
import 'package:repair_project/ui/MainScreen.dart';
import 'package:repair_project/ui/order/bottom_bar_helper.dart';
import 'package:repair_project/ui/order/order_detail_bean/orders.dart';
import 'package:repair_project/ui/order/order_assess.dart';
import 'package:repair_project/ui/pay/pay_%20servicefee.dart';
import 'package:repair_project/ui/pay/pay_page.dart';

class BottomBarWidget extends StatefulWidget{
  Orders orders;

  BottomBarWidget({this.orders});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BottomBarState();
  }

}

class BottomBarState extends State<BottomBarWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.orders !=null?
    // TODO: implement build
    BottomAppBar(
      child: Container(
          margin: EdgeInsets.only(right: 20),
          height: 50.0,
          child: buildBottomButton(),
      ),
    ):Container();
  }

  Widget buildBottomButton() {
    int orderState = widget.orders.orderState;
    switch(orderState){
      case 0:
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            BottomBarHelper().buildPublishButton(context, widget.orders.id, widget.orders.description),
            //buildPublishButton(),
            Padding(
              padding: EdgeInsets.only(right: 5),
            ),
            BottomBarHelper().buildCancelButton(context, widget.orders.id)
            //buildCancelButton()
          ],
        );
      case 5:
        return BottomBarHelper().buildStatusButton("已发布");
      case 7:
        return BottomBarHelper().buildStatusButton("已接单");
      case 10:
        return BottomBarHelper().buildStatusButton("待报价");
      case 15:
        return BottomBarHelper().buildQuotedButton(context,widget.orders.ordersQuote.id,widget.orders.description,widget.orders.ordersQuote.subscriptionMoney.toString());
      case 20:
        return BottomBarHelper().buildStatusButton("已付定金");
      case 22:
        return BottomBarHelper().buildStatusButton("待维修");
      case 25:
        return BottomBarHelper().buildStatusButton("维修中");
      case 30:
        return BottomBarHelper().buildMaintainFinishedButton(context,widget.orders.ordersQuote.balanceMoney.toString(),widget.orders.id,widget.orders.description);
      case 35:
        return BottomBarHelper().buildWaitingForFeedbackButton(context,widget.orders.orderNumber,widget.orders.id);
      case 40:
        return BottomBarHelper().buildStatusButton("已评价");
    }
  }



}