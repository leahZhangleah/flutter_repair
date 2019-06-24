import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_project/entity/qoinfo.dart';
import 'package:repair_project/http/HttpUtils.dart';
import 'package:repair_project/http/api_request.dart';
import 'package:repair_project/ui/order/bottom_bar_helper.dart';
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
            child: ListView.builder(
                  itemCount: rfqOrders.length==0?1:rfqOrders.length,
                  itemBuilder: (context, index) {
                    if(rfqOrders.length==0){
                      return Center(child: Text("暂无相关数据~"),);
                    }
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
                                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
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
                                                  padding:EdgeInsets.only(left: 20),
                                                  child: Text("维修员",style: TextStyle(fontSize: 18,color: Colors.black))),
                                            ],
                                          ),
                                          Align(
                                            child: Text("已报价",
                                              style: TextStyle(color: Colors.lightBlue),
                                            ),
                                            alignment:FractionalOffset.centerRight,
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      height: 2,
                                      color: Colors.grey,
                                    ),
                                    Row(
                                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(flex:3,child:Column(
                                          crossAxisAlignment:CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                                padding: EdgeInsets.only(top: 10, bottom: 20),
                                                child: Text(
                                                    rfqOrder.description,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black))),
                                            Text("#" + rfqOrder.type,style: TextStyle(color: Colors.lightBlue),),
                                            Padding(
                                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                                child: Text(rfqOrder.createTime,style: TextStyle(color: Colors.grey)))
                                          ],
                                        )),
                                        Column(
                                          mainAxisAlignment:MainAxisAlignment.center,
                                          crossAxisAlignment:CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              child: Text("定金：" +rfqOrder.ordersQuote.subscriptionMoney.toString() +"元",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              padding: EdgeInsets.only(top: 10),
                                            ),
                                            Padding(
                                              child: Text(
                                                "尾款：" +rfqOrder.ordersQuote.balanceMoney.toString() +"元",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              padding: EdgeInsets.only(top: 10),
                                            ),
                                            Padding(
                                              child: Text(
                                                "合计：" +rfqOrder.ordersQuote.quoteMoney.toString() +"元",
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
                                      mainAxisAlignment:MainAxisAlignment.end,
                                      children: <Widget>[
                                        BottomBarHelper().buildQuotedButton(context, rfqOrder.id, rfqOrder.description, rfqOrder.ordersQuote.subscriptionMoney.toString())
                                      ],
                                    )
                                        : rfqOrder.orderState == 30
                                        ? Align(
                                        alignment:
                                        FractionalOffset.bottomRight,
                                        child: BottomBarHelper().buildMaintainFinishedButton(context, rfqOrder.ordersQuote.balanceMoney.toString(), rfqOrder.id, rfqOrder.description))
                                        : Align(alignment:FractionalOffset.bottomRight,
                                        child: rfqOrder.orderState == 22?
                                          BottomBarHelper().buildStatusButton("待维修"):
                                          BottomBarHelper().buildStatusButton("维修中")
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ));
                  }
    )));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
