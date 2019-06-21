import 'package:flutter/material.dart';
import 'package:repair_project/ui/order/order_detail_bean/orders.dart';
import 'package:repair_project/ui/order/order_detail_bean/orders_quote.dart';

class QuoteDetailWidget extends StatelessWidget{
  Orders orders;
  QuoteDetailWidget({this.orders});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    OrdersQuote ordersQuote = orders.ordersQuote;
    return  ordersQuote!=null?
    new Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Text("定金: ")),
                    Container(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Text("尾款: ")),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Text("￥" +
                            ordersQuote.subscriptionMoney
                                .toString() +
                            "元")),
                    Container(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Text("￥" +
                            ordersQuote.balanceMoney
                                .toString() +
                            "元")),
                  ],
                ),
              ],
            ),
            Divider(
              height: 1,
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text("总付款: ")),
                Container(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text("￥" +
                        ordersQuote.quoteMoney.toString() +
                        "元"))
              ],
            )
          ],
        )):Container();
  }

}