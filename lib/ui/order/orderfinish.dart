import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_project/entity/order.dart';
import 'package:repair_project/entity/qoinfo.dart';
import 'package:repair_project/http/HttpUtils.dart';
import 'package:repair_project/http/api_request.dart';
import 'package:repair_project/ui/order/order_assess.dart';
import 'package:repair_project/ui/order/order_details.dart';
import 'package:repair_project/ui/order/rfqorderdetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderFinish extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OrderFinishState();
  }
}

class OrderFinishState extends State<OrderFinish>
    with AutomaticKeepAliveClientMixin {
  int nowPage = 1;
  int limit = 5;
  int total = 0;
  List<QoInfo> _finishedOrders = [];
  String url = "";


  @override
  void initState() {
    getFinishedOrder(nowPage, limit);
    super.initState();
  }

  //已完成订单列表
  Future<void> getFinishedOrder(int nowPage, int limit) async {
    ResultModel resultModel = await ApiRequest().getOrderListForDiffType(nowPage, limit, "four"); //"four" represents for 已完成
    print(resultModel.data.toString());
    setState(() {
      _finishedOrders = QoInfo.allFromResponse(resultModel.data.toString());
      total = json
          .decode(resultModel.data.toString())
          .cast<String, dynamic>()['page']['total'];
      url = json
          .decode(resultModel.data.toString())
          .cast<String, dynamic>()['fileUploadServer'];
    });
    print(total);
  }

  //下拉刷新
  Future<Null> onHeaderRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      setState(() {
        nowPage = 1;
        limit = 5;
        getFinishedOrder(nowPage, limit);
      });
    });
  }

  //上拉加载更多
  Future<Null> onFooterRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      setState(() {
        nowPage += 1;
        //limit += 5;
        if (_finishedOrders.length > total) {
          Fluttertoast.showToast(msg: "没有更多的订单了");
        } else {
          getFinishedOrder(nowPage, limit);
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
                itemCount: _finishedOrders.length,
                itemBuilder: (context, index) {
                  var finishOrder = _finishedOrders[index];
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
                                        return new RFQOrderDetails(ordertype: "已报价",
                                            description: finishOrder.description,
                                            name: finishOrder.contactsName,
                                            phone: finishOrder.contactsPhone,
                                            address: finishOrder.contactsAddress,
                                            ordernumber: finishOrder.orderNumber,
                                            createTime: finishOrder.createTime,
                                            type: finishOrder.type,
                                            videopath: url + finishOrder.url,
                                            id: finishOrder.id,
                                            state: finishOrder.orderState,
                                            subscriptionMoney:
                                            finishOrder.subscriptionMoney,
                                            balanceMoney: finishOrder.balanceMoney,
                                            quoteMoney: finishOrder.quoteMoney);
                                      })),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                      padding:
                                      EdgeInsets.only(top: 5, bottom: 20),
                                      child: Text(finishOrder.description,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black))),
                                  Text(
                                    "#" + finishOrder.type,
                                    style: TextStyle(color: Colors.lightBlue),
                                  ),
                                  Padding(
                                      padding:
                                      EdgeInsets.only(top: 5, bottom: 5),
                                      child: Text(finishOrder.createTime,
                                          style:
                                          TextStyle(color: Colors.grey))),
                                  Divider(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
                                  Align(
                                      alignment: FractionalOffset.bottomRight,
                                      child: OutlineButton(
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.grey),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: finishOrder.orderState==35?Text("评价",
                                              style: new TextStyle(
                                                  color: Colors.black)):Text("已评价",style: new TextStyle(
                                              color: Colors.black)),
                                          onPressed: (){
                                            finishOrder.orderState==35?
                                            Navigator.of(context).push(
                                              new MaterialPageRoute(
                                                builder: (c) {
                                                  return new Assess(ordersNumber:finishOrder.orderNumber,ordersId:finishOrder.id);
                                                },
                                              ),
                                            ).then((_){
                                              getFinishedOrder(nowPage, limit);
                                            }):null;
                                          }))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                })));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
