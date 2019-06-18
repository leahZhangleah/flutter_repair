import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_project/entity/order.dart';
import 'package:repair_project/http/HttpUtils.dart';
import 'package:repair_project/ui/order/order_details.dart';
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
  List<Order> _yetReceiveOrder = [];
  String url = "";

  @override
  void initState() {
    getYetReceiveOrder(nowPage, limit);
    super.initState();
  }

  //未接单订单列表
  Future<void> getYetReceiveOrder(int nowPage, int limit) async {
    ResultModel resultModel = await ApiRequest().getOrderListForDiffType(context,nowPage, limit, "one"); //"one" represents yet received orders
    if(mounted){
      setState(() {
        _yetReceiveOrder.addAll(Order.allFromResponse(resultModel.data.toString())) ;
        total = json
            .decode(resultModel.data.toString())
            .cast<String, dynamic>()['page']['total'];
        url = json
            .decode(resultModel.data.toString())
            .cast<String, dynamic>()['fileUploadServer'];
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
        //limit += 5;
        if (_yetReceiveOrder.length > total) {
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
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: Refresh(
            onFooterRefresh: onFooterRefresh,
            onHeaderRefresh: onHeaderRefresh,
            child: ListView.builder(
                itemCount: _yetReceiveOrder.length,
                itemBuilder: (context, index) {
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
                                    return new OrderDetiails(
                                        ordertype: "未接单",
                                        state: missedOrder.orderState,
                                        description: missedOrder.description,
                                        name: missedOrder.contactsName,
                                        phone: missedOrder.contactsPhone,
                                        address: missedOrder.contactsAddress,
                                        ordernumber: missedOrder.orderNumber,
                                        createTime: missedOrder.createTime,
                                        type: missedOrder.type,
                                        videopath: url + missedOrder.url,
                                        id: missedOrder.id);
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
                                              ? OutlineButton(
                                                  borderSide: BorderSide(
                                                      width: 1,
                                                      color: Colors.lightBlue),
                                                  color: Colors.lightBlue,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5))),
                                                  child: Text("确认发布",
                                                      style: new TextStyle(
                                                          color: Colors
                                                              .lightBlue)),
                                                  onPressed: () {
                                                    showDialog<bool>(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return CupertinoAlertDialog(
                                                          title:
                                                              CupertinoDialogAction(
                                                            child: Text(
                                                              "订单发布",
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .redAccent),
                                                            ),
                                                          ),
                                                          content:
                                                              CupertinoDialogAction(
                                                            child: Text(
                                                              "发布订单需要支付￥20元的服务费",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          actions: <Widget>[
                                                            CupertinoDialogAction(
                                                              onPressed: () =>
                                                                  Navigator.push(
                                                                      context,
                                                                      new MaterialPageRoute(builder:
                                                                          (BuildContext
                                                                              context) {
                                                                    return new Payfee(
                                                                        id: missedOrder
                                                                            .id,
                                                                        des: missedOrder
                                                                            .description);
                                                                  })).then((_){
                                                                    Navigator.pop(context);
                                                                    onHeaderRefresh();
                                                                  }),
                                                              child: Container(
                                                                child: Text(
                                                                  "确定",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                            ),
                                                            CupertinoDialogAction(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Container(
                                                                child: Text(
                                                                  "取消",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  })
                                              : Text("已发布",
                                              style: new TextStyle(
                                                  color: Colors.black)),
                                          Padding(
                                            padding: EdgeInsets.only(right: 5),
                                          ),
                                          missedOrder.orderState == 0?
                                          OutlineButton(
                                              borderSide: BorderSide(
                                                  width: 1, color: Colors.grey),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
                                              child: Text("取消订单",
                                                  style: new TextStyle(
                                                      color: Colors.black)),
                                              onPressed: () {
                                                showDialog<bool>(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (context) {
                                                    return CupertinoAlertDialog(
                                                      title:
                                                          CupertinoDialogAction(
                                                        child: Text(
                                                          "确认取消",
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              color: Colors
                                                                  .redAccent),
                                                        ),
                                                      ),
                                                      content:
                                                          CupertinoDialogAction(
                                                        child: Text(
                                                          "订单取消后不可恢复",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        CupertinoDialogAction(
                                                          onPressed: () =>
                                                              ApiRequest().cancelOrder(context,missedOrder.id).then((_){
                                                                        Navigator.of(context).pop();
                                                                        onHeaderRefresh();
                                                              }),
                                                          child: Container(
                                                            child: Text(
                                                              "确定",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ),
                                                        CupertinoDialogAction(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Container(
                                                            child: Text(
                                                              "取消",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }):new Container()
                                        ],
                                      ))
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
