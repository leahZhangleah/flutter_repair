import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_project/entity/order.dart';
import 'package:repair_project/http/HttpUtils.dart';
import 'package:repair_project/ui/order/order_detail_bean/orders.dart';
import 'package:repair_project/ui/order/order_details.dart';
import 'package:repair_project/ui/order/order_list_bean/page.dart';
import 'package:repair_project/ui/order/rfqorderdetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:repair_project/http/http_address_manager.dart';
import 'package:repair_project/http/api_request.dart';

class OrderRFQ extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OrderRFQState();
  }
}

class OrderRFQState extends State<OrderRFQ> with AutomaticKeepAliveClientMixin {
  int nowPage = 1;
  int limit = 5;
  int total = 0;
  List<Orders> rfqOrders = [];

  @override
  void initState() {
    super.initState();
    getWaitingForQuoteOrder(nowPage, limit);
  }

  //待报价订单列表
  Future<void> getWaitingForQuoteOrder(int nowPage, int limit) async {
   Page page = await ApiRequest().getOrderListForDiffType(context,nowPage, limit,"two"); //"two" represents waiting for quote
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
        getWaitingForQuoteOrder(nowPage, limit);
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
          getWaitingForQuoteOrder(nowPage, limit);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                                          return new OrderDetails(
                                            orderId: rfqOrder.id,
                                          );
                                        })),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(padding: EdgeInsets.only(top: 5,bottom: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(children: <Widget>[
                                            ClipOval(
                                              child: FadeInImage.assetNetwork(
                                                placeholder: "assets/images/person_placeholder.png",
                                                fit: BoxFit.fitWidth,
                                                //todo: get quoter's image
                                                image:
                                                "https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=3463668003,3398677327&fm=58",
                                                width: 50.0,
                                              ),
                                            ),
                                            Padding(padding:EdgeInsets.only(left: 20),child:Text("报价员",style: TextStyle(fontSize: 18,color: Colors.black))),
                                          ],),
                                          Align(
                                            child: Text("等待报价",style: TextStyle(color: Colors.lightBlue),),
                                            alignment: FractionalOffset.centerRight,)
                                        ],),),
                                    Divider(height: 2,color: Colors.grey,),
                                    Padding(
                                        padding:
                                        EdgeInsets.only(top: 5, bottom: 20),
                                        child: Text(rfqOrder.description,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black))),
                                    Text(
                                      "#" + rfqOrder.type,
                                      style: TextStyle(color: Colors.lightBlue),
                                    ),
                                    Padding(
                                        padding:
                                        EdgeInsets.only(top: 5, bottom: 5),
                                        child: Text(rfqOrder.createTime,
                                            style:
                                            TextStyle(color: Colors.grey))),
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
