import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_project/entity/order.dart';
import 'package:repair_project/http/HttpUtils.dart';
import 'package:repair_project/ui/order/bottom_bar_helper.dart';
import 'package:repair_project/ui/order/order_detail_bean/orders.dart';
import 'package:repair_project/ui/order/order_details.dart';
import 'package:repair_project/ui/order/order_list_bean/page.dart';
import 'package:repair_project/ui/pay/pay_ servicefee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:repair_project/http/http_address_manager.dart';
import 'package:repair_project/http/api_request.dart';

class OrderMissed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OrderMissedState();
  }
}

class OrderMissedState extends State<OrderMissed>
    with AutomaticKeepAliveClientMixin {
  int nowPage = 1;
  int limit = 5;
  int total = 0;
  List<Orders> _yetReceiveOrder = [];
  String serviceCharge;

  @override
  void initState() {
    getYetReceiveOrder(nowPage, limit);
    ApiRequest().getServiceCharge().then((charge){
      serviceCharge = charge;
    });
    super.initState();
  }

  //未接单订单列表
  Future<void> getYetReceiveOrder(int nowPage, int limit) async {
    Page page = await ApiRequest().getOrderListForDiffType(context,nowPage, limit, "one"); //"one" represents yet received orders
    if(mounted){
      setState(() {
        _yetReceiveOrder.addAll(page.orders) ;
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
        _yetReceiveOrder.clear();
        getYetReceiveOrder(nowPage, limit);
      });
    });
  }

  //上拉加载更多
  Future<Null> onFooterRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      setState(() {
        nowPage += 1;
        if (_yetReceiveOrder.length >= total) {
          Fluttertoast.showToast(msg: "没有更多的订单了");
        } else {
          getYetReceiveOrder(nowPage, limit);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      //color: Colors.grey[200],
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: Refresh(
            onFooterRefresh: onFooterRefresh,
            onHeaderRefresh: onHeaderRefresh,
            child: ListView.builder(
                  itemCount: _yetReceiveOrder.length ==0? 1:_yetReceiveOrder.length,
                  itemBuilder: (context, index) {
                    if(_yetReceiveOrder.length==0){
                      return Center(child: Text("暂无相关数据~"),);
                    }
                    var missedOrder = _yetReceiveOrder[index];
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
                                          return new OrderDetails(
                                            orderId: missedOrder.id,
                                          );
                                        })),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                        padding:
                                        EdgeInsets.only(top: 5, bottom: 20),
                                        child: Text(missedOrder.description,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black))),
                                    Text(
                                      "#" + missedOrder.type,
                                      style: TextStyle(color: Colors.lightBlue),
                                    ),
                                    Padding(
                                        padding:
                                        EdgeInsets.only(top: 5, bottom: 5),
                                        child: Text(missedOrder.createTime,
                                            style:
                                            TextStyle(color: Colors.grey))),
                                    Divider(
                                      height: 2,
                                      color: Colors.grey,
                                    ),
                                    Align(
                                        alignment: FractionalOffset.bottomRight,
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: <Widget>[
                                            missedOrder.orderState == 0
                                                ? BottomBarHelper().buildPublishButton(context, missedOrder.id, missedOrder.description)
                                                : BottomBarHelper().buildStatusButton("已发布"),
                                            Padding(
                                              padding: EdgeInsets.only(right: 5),
                                            ),
                                            missedOrder.orderState == 0?
                                            BottomBarHelper().buildCancelButton(context, missedOrder.id):new Container()
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ));
                  })
    ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
