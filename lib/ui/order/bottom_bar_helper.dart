import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repair_project/http/api_request.dart';
import 'package:repair_project/ui/MainScreen.dart';
import 'package:repair_project/ui/order/order_assess.dart';
import 'package:repair_project/ui/pay/pay_%20servicefee.dart';
import 'package:repair_project/ui/pay/pay_page.dart';
class BottomBarHelper{
  Widget buildPublishButton(BuildContext context,String id,String description){
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
        onPressed: ()=>showPublishConfirmDialog(context,id,description));
  }

  void showPublishConfirmDialog(BuildContext context,String id,String description) async{
    String serviceCharge = await ApiRequest().getServiceCharge();
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
            child: Text("发布订单需要支付 ￥ $serviceCharge 元的服务费", //todo
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () =>
                  Navigator.push(context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) {
                            return new Payfee(id:id,des:description);
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

  Widget buildCancelButton(BuildContext context,String id){
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
        onPressed: ()=>showCancelOrderDialog(context,id));
  }

  void showCancelOrderDialog(BuildContext context,String id) {
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
                  ApiRequest().cancelOrder(context, id).then((_){
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

  Widget buildStatusButton(String status){
    return OutlineButton(
      borderSide: BorderSide(width: 1, color: Colors.lightBlue),
      disabledBorderColor: Colors.grey[200],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Text(status, style: new TextStyle(color: Colors.black)),
    );
  }

  Widget buildQuotedButton(BuildContext context,String id,String description,String subscriptionMoney){
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
              onPressed: ()=>refuseQuoteDialog(context,id),
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
                        cost: num.parse(subscriptionMoney),
                        type: 5,
                        orderId: id,
                        des: description);
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

  void refuseQuoteDialog(BuildContext context,String id){
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
              onPressed: () => ApiRequest().refuseOrderQuote(context,id),
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


  Widget buildMaintainFinishedButton(BuildContext context,String balanceMoney,String id,String description){
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
                            cost: num.parse(balanceMoney),
                            type:10,
                            orderId: id,
                            des: description);
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

  Widget buildWaitingForFeedbackButton(BuildContext context,String orderNumber,String id){
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
                    return new Assess(ordersNumber:orderNumber,ordersId:id);
                  },
                ),
              )
              /* .then((_){
                onHeaderRefresh();
              })*/;
            }));
  }
}