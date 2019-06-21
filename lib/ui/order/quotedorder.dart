import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_project/entity/qoinfo.dart';
import 'package:repair_project/http/HttpUtils.dart';
import 'package:repair_project/http/api_request.dart';
import 'package:repair_project/ui/order/order_detail_bean/orders.dart';
import 'package:repair_project/ui/order/order_details.dart';
import 'package:repair_project/ui/order/order_list_bean/page.dart';
import 'package:repair_project/ui/order/rfqorderdetails.dart';
import 'package:repair_project/ui/pay/pay_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderQuote extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OrderQuoteState();
  }
}

class OrderQuoteState extends State<OrderQuote>
    with AutomaticKeepAliveClientMixin {
  int nowPage = 1;
  int limit = 5;
  int total = 0;
  List<Orders> rfqOrders = [];

  @override
  void initState() {
    getQuotedOrder(nowPage, limit);
    super.initState();
  }

  //已报价订单列表
  Future<void> getQuotedOrder(int nowPage, int limit) async {
    Page page = await ApiRequest().getOrderListForDiffType(context,nowPage, limit, "three"); //"three" represents for 已报价
   if(mounted){
     setState(() {
       rfqOrders.addAll(page.orders);
       total = page.total;
     });
     print(total);
   }
  }

  //下拉刷新
  Future<Null> onHeaderRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      setState(() {
        nowPage = 1;
        limit = 5;
        rfqOrders.clear();
        getQuotedOrder(nowPage, limit);
      });
    });
  }

  //上拉加载更多
  Future<Null> onFooterRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      setState(() {
        nowPage += 1;
        //limit += 5;
        if (rfqOrders.length >= total) {
          Fluttertoast.showToast(msg: "没有更多的订单了");
        } else {
          getQuotedOrder(nowPage, limit);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: Refresh(
            onFooterRefresh: onFooterRefresh,
            onHeaderRefresh: onHeaderRefresh,
            childBuilder:(BuildContext context, {ScrollController controller,ScrollPhysics physics}){
              return rfqOrders.isEmpty?Text("没有更多的订单"):
              ListView.builder(
                  itemCount: rfqOrders.length,
                  itemBuilder: (context, index) {
                    var rfqOrder = rfqOrders[index];
                    return Padding(
                        padding: EdgeInsets.fromLTRB(10, 15, 10, 5),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                onTap: () => Navigator.push(context,
                                    new MaterialPageRoute(
                                        builder: (BuildContext context) {
                                          return OrderDetails(orderId: rfqOrder.id,);
                                        })),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 5, bottom: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              ClipOval(
                                                child: FadeInImage.assetNetwork(
                                                  placeholder:
                                                  "assets/images/person_placeholder.png",
                                                  fit: BoxFit.fitWidth,
                                                  image:
                                                  "https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=3463668003,3398677327&fm=58",
                                                  width: 50.0,
                                                ),
                                              ),
                                              Padding(
                                                  padding:
                                                  EdgeInsets.only(left: 20),
                                                  child: Text("维修员",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.black))),
                                            ],
                                          ),
                                          Align(
                                            child: Text(
                                              "已报价",
                                              style: TextStyle(
                                                  color: Colors.lightBlue),
                                            ),
                                            alignment:
                                            FractionalOffset.centerRight,
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      height: 2,
                                      color: Colors.grey,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(flex:3,child:Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    top: 10, bottom: 20),
                                                child: Text(
                                                    rfqOrder.description,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black))),
                                            Text(
                                              "#" + rfqOrder.type,
                                              style: TextStyle(
                                                  color: Colors.lightBlue),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    top: 5, bottom: 5),
                                                child: Text(
                                                    rfqOrder.createTime,
                                                    style: TextStyle(
                                                        color: Colors.grey)))
                                          ],
                                        )),
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              child: Text(
                                                "定金：" +
                                                    rfqOrder.ordersQuote.subscriptionMoney
                                                        .toString() +
                                                    "元",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              padding: EdgeInsets.only(top: 10),
                                            ),
                                            Padding(
                                              child: Text(
                                                "尾款：" +
                                                    rfqOrder.ordersQuote.balanceMoney
                                                        .toString() +
                                                    "元",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              padding: EdgeInsets.only(top: 10),
                                            ),
                                            Padding(
                                              child: Text(
                                                "合计：" +
                                                    rfqOrder.ordersQuote.quoteMoney
                                                        .toString() +
                                                    "元",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              padding: EdgeInsets.only(top: 10),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    Divider(
                                      height: 2,
                                      color: Colors.grey,
                                    ),
                                    rfqOrder.orderState == 15
                                        ? Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: <Widget>[
                                        OutlineButton(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.lightBlue),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(5))),
                                          onPressed: () =>
                                              Navigator.push(context,
                                                  new MaterialPageRoute(
                                                      builder: (BuildContext
                                                      context) {
                                                        return new Paypage(
                                                            tile: "支付定金",
                                                            cost: num.parse(rfqOrder.ordersQuote.subscriptionMoney.toString()),
                                                            type:5,
                                                            orderId: rfqOrder.id,
                                                            des: rfqOrder
                                                                .description);
                                                      })),
                                          child: Container(
                                            child: Text("付定金",
                                                style: new TextStyle(
                                                    color:
                                                    Colors.lightBlue)),
                                          ),
                                        )
                                      ],
                                    )
                                        : rfqOrder.orderState == 30
                                        ? Align(
                                        alignment:
                                        FractionalOffset.bottomRight,
                                        child: OutlineButton(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.lightBlue),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(
                                                      5))),
                                          onPressed: () =>
                                              Navigator.push(context,
                                                  new MaterialPageRoute(
                                                      builder: (BuildContext
                                                      context) {
                                                        return new Paypage(
                                                            tile: "支付尾款",
                                                            cost: num.parse(rfqOrder.ordersQuote.balanceMoney.toString()),
                                                            type:10,
                                                            orderId: rfqOrder.id,
                                                            des: rfqOrder
                                                                .description);
                                                      })),
                                          child: Container(
                                              child: RichText(
                                                  textScaleFactor: 1.0,
                                                  text: TextSpan(
                                                      text: '(维修已完成) ',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey),
                                                      children: <
                                                          TextSpan>[
                                                        TextSpan(
                                                            text: '付尾款',
                                                            style: TextStyle(
                                                                fontSize:
                                                                16,
                                                                color: Colors
                                                                    .lightBlue)),
                                                      ]),
                                                  textAlign:
                                                  TextAlign.center)),
                                        ))
                                        : Align(
                                        alignment:
                                        FractionalOffset.bottomRight,
                                        child: OutlineButton(
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Colors.lightBlue),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(
                                                      5))),
                                          onPressed: null,
                                          child: Container(
                                              child: rfqOrder
                                                  .orderState == 22
                                                  ? Text("待维修",
                                                  style: new TextStyle(
                                                      color: Colors
                                                          .lightBlue))
                                                  : Text("维修中",
                                                  style: new TextStyle(
                                                      color: Colors
                                                          .lightBlue))),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ));
                  });
            }

    ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
