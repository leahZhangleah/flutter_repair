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

  Widget buildPublishButton(){
    return OutlineButton(
        borderSide: BorderSide(
            width: 1,
            color: Colors.lightBlue),
        color: Colors.lightBlue,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(5))),
        child: Text("确认发布",
            style: new TextStyle(
                color: Colors.lightBlue)),
        onPressed: showPublishConfirmDialog);
  }
  
  Widget buildStatusButton(String status){
    return OutlineButton(
      borderSide: BorderSide(width: 1, color: Colors.lightBlue),
      disabledBorderColor: Colors.grey[200],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Text(status, style: new TextStyle(color: Colors.black)),
    );
  }

  Widget buildCancelButton(){
    return OutlineButton(
        borderSide: BorderSide(
            width: 1, color: Colors.grey),
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(
                Radius.circular(5))),
        child: Text("取消订单",
            style: new TextStyle(
                color: Colors.black)),
        onPressed: showCancelOrderDialog);
  }

  Widget buildQuotedButton(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: 10),
            child: OutlineButton(
              borderSide:
              BorderSide(width: 1, color: Colors.grey),
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(5))),
              onPressed: refuseQuoteDialog,
              child: Container(
                child: Text("拒绝报价",
                    style:
                    new TextStyle(color: Colors.black)),
              ),
            )),
        OutlineButton(
          borderSide:
          BorderSide(width: 1, color: Colors.lightBlue),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          onPressed: () => Navigator.push(context,
              new MaterialPageRoute(
                  builder: (BuildContext context) {
                    return new Paypage(
                        tile: "支付定金",
                        cost: num.parse(widget.orders.ordersQuote.subscriptionMoney.toString()),
                        type: 5,
                        orderId: widget.orders.id,
                        des: widget.orders.description);
                  })),
          child: Container(
            child: Text("付定金",
                style:
                new TextStyle(color: Colors.lightBlue)),
          ),
        )
      ],
    );
  }

  Widget buildMaintainFinishedButton(){
    return Align(
        alignment: FractionalOffset.bottomRight,
        child: OutlineButton(
          borderSide: BorderSide(width: 1, color: Colors.lightBlue),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          onPressed: () =>
              Navigator.push(context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) {
                        return new Paypage(
                            tile: "支付尾款",
                            cost: num.parse(widget.orders.ordersQuote.balanceMoney.toString()),
                            type:10,
                            orderId: widget.orders.id,
                            des: widget.orders.description);
                      })),
          child: Container(
              child: RichText(
                  textScaleFactor: 1.0,
                  text: TextSpan(text: '(维修已完成) ', style: TextStyle(color: Colors.grey),
                      children: <TextSpan>[
                        TextSpan(
                            text: '付尾款',
                            style: TextStyle(fontSize: 16, color: Colors.lightBlue)),
                      ]),
                  textAlign: TextAlign.center)),
        ));
  }

  Widget buildWaitingForFeedbackButton(){
    return Align(
        alignment: FractionalOffset.bottomRight,
        child: OutlineButton(
            borderSide: BorderSide(
                width: 1, color: Colors.grey),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(5))),
            child: Text("待评价", style: new TextStyle(color: Colors.black)),
            onPressed: (){
              Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (c) {
                    return new Assess(ordersNumber:widget.orders.orderNumber,ordersId:widget.orders.id);
                  },
                ),
              )
              /* .then((_){
                onHeaderRefresh();
              })*/;
            }));
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
        return BottomBarHelper().buildQuotedButton(context,widget.orders.id,widget.orders.description,widget.orders.ordersQuote.subscriptionMoney.toString());
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

  void refuseQuoteDialog(){
    showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: CupertinoDialogAction(
            child: Text("确认拒绝", style: TextStyle(fontSize: 18, color: Colors.redAccent),
            ),
          ),
          content: CupertinoDialogAction(
            child: Text("拒绝后将会进行重新报价", style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () => ApiRequest().refuseOrderQuote(context,widget.orders.id),
              child: Container(
                child: Text("确定", style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Container(
                child: Text("取消", style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showPublishConfirmDialog() {
    showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: CupertinoDialogAction(
            child: Text(
              "订单发布", style: TextStyle(fontSize: 18, color: Colors.redAccent),
            ),
          ),
          content: CupertinoDialogAction(
            child: Text("发布订单需要支付￥20元的服务费", //todo
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () =>
                  Navigator.push(context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) {
                            return new Payfee(id:widget.orders.id,des:widget.orders.description);
                          })),
              child: Container(
                child: Text("确定", style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Container(
                child: Text("取消", style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  void showCancelOrderDialog() {
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
                  color: Colors.redAccent),
            ),
          ),
          content:
          CupertinoDialogAction(
            child: Text(
              "订单取消后不可恢复",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () =>
                  ApiRequest().cancelOrder(context, widget.orders.id).then((_){
                    Navigator.pop(context);
                    Navigator.of(context).pushAndRemoveUntil(
                        new MaterialPageRoute(builder: (c) => new Main(tabindex: 1,)
                        ), (route) => route == null);
                  }),
              child: Container(
                child: Text(
                  "确定",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Container(
                child: Text(
                  "取消",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
            ),
          ],
        );
      },
    );
  }


}