import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_project/entity/payment.dart';
import 'package:repair_project/http/HttpUtils.dart';
import 'package:repair_project/ui/MainScreen.dart';
import 'package:repair_project/ui/coupon/coupon_description.dart';
import 'package:repair_project/ui/coupon/coupon_response.dart';
import 'package:repair_project/ui/coupon/coupon_usable.dart';
import 'package:repair_project/ui/order/orderlist.dart';
import 'package:repair_project/widgets/bottom_button.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:repair_project/http/http_address_manager.dart';
import 'package:repair_project/http/api_request.dart';

class Paypage extends StatefulWidget {
  final String tile, des, orderId;
  final double cost;
  final int type;

  Paypage({this.des, this.orderId, this.tile, this.cost, this.type});

  @override
  State<StatefulWidget> createState() {
    return PaypageState();
  }
}

class PaypageState extends State<Paypage> {
  bool choose = true;
  Payment payment;
  var cList;
  List<CouponDescription> couponList;
  num moneyAmount = 0;
  String couponId = '';
  bool isWechatInstalled;

  void initState() {
    super.initState();
    initWechat();

    cList = ApiRequest().fetchUsableCouponList(context,widget.cost);
    fluwx.responseFromPayment.listen((data) {
      print(data.errCode);
    });
  }

  void initWechat()async {
    isWechatInstalled = await ApiRequest().initFluwx();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("支付页"),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(30),
              child: RichText(
                  textScaleFactor: 1.5,
                  text: TextSpan(
                      text: widget.tile + '\n',
                      style: TextStyle(fontSize: 20.0, color: Colors.grey),
                      children: <TextSpan>[
                        TextSpan(
                            text: '￥' + widget.cost.toString() + '元',
                            style:
                                TextStyle(fontSize: 28.0, color: Colors.black)),
                      ]),
                  textAlign: TextAlign.center)),
          Container(
            height: 20,
            color: Colors.grey[200],
          ),
          FutureBuilder(
            future: cList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  couponList = snapshot.data;
                  return Container(
                    margin: EdgeInsets.only(
                        left: 30, right: 10, top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "优惠券",
                          style: TextStyle(fontSize: 18),
                        ),
                        GestureDetector(
                          child: Row(
                            children: <Widget>[
                              moneyAmount == 0
                                  ? RichText(
                                      text: TextSpan(
                                          text: couponList.length.toString(),
                                          style: TextStyle(
                                              fontSize: 18, color: Colors.red),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: ' 个可用',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ]),
                                      textAlign: TextAlign.center)
                                  : Text(
                                      "已优惠" + moneyAmount.toString() + "元",
                                      style: TextStyle(fontSize: 18),
                                    ),
                              IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          ),
                          onTap: () => Navigator.of(context).push(
                                new MaterialPageRoute(
                                  builder: (c) {
                                    return new CouponUsable(
                                        couponDescription: couponList);
                                  },
                                ),
                              ).then((res) {
                                setState(() {
                                  moneyAmount = res[0];
                                  couponId = res[1];
                                });
                              }),
                        )
                      ],
                    ),
                  );
                } else {
                  //todo: the data fetched from internet is null
                  return new Container();
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return new Container(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.connectionState == ConnectionState.none) {
                //todo: show a toast
                return Text("请检查网络");
              }
            },
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            height: 20,
            color: Colors.grey[200],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    child: Image.asset(
                      "images/wxpay.png",
                      fit: BoxFit.fitHeight,
                    ),
                    padding: EdgeInsets.only(left: 15, right: 15),
                  ),
                  Text(
                    "微信支付",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              CircularCheckBox(
                value: choose,
                onChanged: (bool) => choose = !choose,
                activeColor: Colors.blue,
              ),
            ],
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(color: Colors.grey[200]),
            ),
          ),
          NextButton(
            text: "立即支付￥" + ((widget.cost - moneyAmount) <= 0
                ? 0.01
                : (widget.cost - moneyAmount)).toString() + "元",
            onNext: (){
              if(isWechatInstalled){
                ApiRequest().paySubOrBal(context, widget.orderId, widget.type, widget.cost, moneyAmount, couponId);
              }else{
                Fluttertoast.showToast(msg: "请先安装微信");
              }
            },
            padingHorzation: 20.0,
          )
        ],
      ),
    );
  }


}
