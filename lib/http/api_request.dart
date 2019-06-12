
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_project/constant/constant.dart';
import 'package:repair_project/entity/payment.dart';
import 'package:repair_project/http/HttpUtils.dart';
import 'package:repair_project/http/http_address_manager.dart';
import 'package:repair_project/ui/MainScreen.dart';
import 'package:repair_project/ui/coupon/coupon_description.dart';
import 'package:repair_project/ui/coupon/coupon_response.dart';
import 'package:repair_project/ui/login/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:flutter/material.dart';

class ApiRequest{
  
  Future<String> getToken()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    return token;
  }
  
  //todo:coupon
  Future<List<CouponDescription>> fetchUsableCouponList(double orderAmount) async {
    //todo: figure out parameters needed for coupon list request
    bool internet = await RequestManager.hasInternet();
    if(internet){
      String token = await getToken();
      RequestManager.baseHeaders = {"token": token};
      String couponListUrl = HttpAddressMananger().usableCouponList;
      ResultModel response = await RequestManager.requestGet(couponListUrl, {'orderAmount':orderAmount});
      var json = jsonDecode(response.data.toString());
      return CouponResponse.fromJson(json).couponList;
    }
  }


  Future<List<CouponDescription>> fetchValidCouponList() async{
    //todo: figure out parameters needed for coupon list request
    bool internet = await RequestManager.hasInternet();
    if(internet) {
      String token = await getToken();
      RequestManager.baseHeaders = {"token": token};
      String couponListUrl = HttpAddressMananger().validCouponList;
      ResultModel response = await RequestManager.requestGet(
          couponListUrl, null);
      var json = jsonDecode(response.data.toString());
      return CouponResponse
          .fromJson(json)
          .couponList;
    }
  }

  //todo: money
  Future<bool> initFluwx() async {
    await fluwx.register(
        appId: HttpAddressMananger().wechatAppId,
        doOnAndroid: true,
        doOnIOS: true,
        enableMTA: false);
    var result = await fluwx.isWeChatInstalled();
    print("is installed $result");
    return result;
  }


  Future payServiceFee(BuildContext context,bool choose,String orderId, num couponValue,String couponId ) async {
    //todo: how to check if user has installed wechat app
    if(choose){
      //    Fluttertoast.showToast(msg: couponId+"###"+moneyAmount);
      String token = await getToken();
      RequestManager.baseHeaders = {"token": token};
      ResultModel response = await RequestManager.requestGet(HttpAddressMananger().wxPay, {
        'tradeType': 'APP',
        'repairsOrdersId': orderId,
        'body': "修宜修-首付服务费",
        'totalPrice': (20-couponValue)<=0?0.01:(20-couponValue),
        'paymentType': 0,
        'couponUserId': couponId
      });


      print(response.data.toString());
      //todo:{"msg":"获取预支付交易会话标识失败","code":500,"state":false}
      Payment payment = Payment.allFromResponse(response.data.toString());

      fluwx.pay(
          appId: payment.appid,
          partnerId: payment.partnerid,
          prepayId: payment.prepayid,
          packageValue: payment.package,
          nonceStr: payment.noncestr,
          timeStamp: num.parse(payment.timestamp),
          sign: payment.sign)
          .then((_) {
        fluwx.responseFromPayment.listen((data) {
          print(data.errCode);
          if (data.errCode == 0) {
            Fluttertoast.showToast(msg: "支付成功，跳转到订单页");
            _payMoneyForService(orderId);
            Navigator.of(context).pushAndRemoveUntil(
                new MaterialPageRoute(
                    builder: (context) => new Main(tabindex: 1)),
                    (route) => route == null);
          }
        });
      });
    }else{
      Fluttertoast.showToast(msg: "请选择支付方式");
    }

  }

  void _payMoneyForService(String id) async {
    String token = await getToken();
    RequestManager.baseHeaders = {"token": token};
    ResultModel response = await RequestManager.requestPost(
        HttpAddressMananger().publishedOrder+id, null);
    print(response.data.toString());
  }


  Future paySubOrBal(BuildContext context,String orderId, int type,double cost,num couponValue,String couponId) async {
    String token = await getToken();
    RequestManager.baseHeaders = {"token": token};
    ResultModel response = await RequestManager.requestGet(HttpAddressMananger().wxPay, {
      'tradeType': 'APP',
      'repairsOrdersId': orderId,
      'body': type == 5 ? "修宜修-定金" : "修宜修-尾款",
      'totalPrice': (cost - couponValue) <= 0
          ? 0.01
          : (cost - couponValue),
      'paymentType': type,
      'couponUserId': couponId
    });
    print(response.data.toString());
    Payment payment = Payment.allFromResponse(response.data.toString());

    fluwx
        .pay(
        appId: payment.appid,
        partnerId: payment.partnerid,
        prepayId: payment.prepayid,
        packageValue: payment.package,
        nonceStr: payment.noncestr,
        timeStamp: int.parse(payment.timestamp),
        sign: payment.sign)
        .then((_) {
      fluwx.responseFromPayment.listen((data) {
        print(data.errCode);
        if (data.errCode == 0) _payMoneyForSubOrBal(type, orderId);
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (context) => new Main(tabindex: 1)),
                (route) => route == null);
      });
    });
  }

  void _payMoneyForSubOrBal(int type, String id) async {
    String token = await getToken();
    RequestManager.baseHeaders = {"token": token};
    if (type == 5) {
      ResultModel response = await RequestManager.requestPost(
          HttpAddressMananger().payEarnest+id, null);
      print(response.data.toString());
    } else {
      ResultModel response = await RequestManager.requestPost(
          HttpAddressMananger().finishOrder+id, null);
      print(response.data.toString());
    }
  }
  
  
  
  //todo:address
  Future<ResultModel> fetchAddressList() async {
    String token = await getToken();
    RequestManager.baseHeaders = {"token": token};
    ResultModel response = await RequestManager.requestGet(
        HttpAddressMananger().addressList, null); // "/repairs/repairsUserAddress/listAll",
    print(response);
    return response;
  }

  Future<void> deleteAddress(String id) async {
    String token = await getToken();
    RequestManager.baseHeaders = {"token": token};
    List<String> ids = new List<String>();
    ids.add(id);
    await RequestManager.requestPost(HttpAddressMananger().addressDelete,ids);//"/repairs/repairsUserAddress/delete",
  }
  
  
  //todo:order
  //不同类型订单列表
  Future<ResultModel> getOrderListForDiffType(int nowPage, int limit,String typeList) async {
    String token = await getToken();
    RequestManager.baseHeaders = {"token": token};
    ResultModel response = await RequestManager.requestGet(
        HttpAddressMananger().orderList,
        {"nowPage": nowPage, "limit": limit, "typeList": typeList});
    print(response.data.toString());
    return response;
  }
  

  //取消订单
  Future<void> cancelOrder(String id) async {
    String token = await getToken();
    RequestManager.baseHeaders = {"token": token};
    ResultModel response = await RequestManager.requestPost(
        HttpAddressMananger().closeOrder+id, null);
    print(response.data.toString());
  }


  //拒绝报价
  Future<void> refuseOrderQuote(String id) async {
    String token = await getToken();
    RequestManager.baseHeaders = {"token": token};
    ResultModel response = await RequestManager.requestPost(
        HttpAddressMananger().refuseQuote+id, null);
    print("refuse quote" + response.data.toString());
    //todo: toast msg to user to tell if user has refused the quote successfully

  }

  //todo:material
  Future<ResultModel> getMaterialList(int nowPage,int limit) async{
    String token = await getToken();
    RequestManager.baseHeaders={"token": token};
    ResultModel response = await RequestManager.requestGet(HttpAddressMananger().materialList,{"page": nowPage, "limit": limit});
    print(response.data.toString());
    return response;
  }

  //todo:logout
//todo: dialog to be sure if user wants to log out
  void logout(BuildContext context) async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    String account = sp.getString("account");
    RequestManager.baseHeaders={"token": token};
    ResultModel response = await RequestManager.requestPost(HttpAddressMananger().logout,null);
    if(json.decode(response.data.toString())["msg"]=="success"){
      sp.remove("token");
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (context) => new RegisterScreen(account)
          ), (route) => route == null);
    };
  }


  //todo:login
Future<void> login(BuildContext context,Dio dio,String phone,String capcha) async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  Response response = await dio.post(
      HttpAddressMananger().getLogin(),
      data: {"phone": phone, "captcha": capcha});

  if(response.data["code"]==500){
    Fluttertoast.showToast(msg: response.data["msg"],gravity: ToastGravity.BOTTOM);
  }else{
    if (response.statusCode == 200) {
      sp.setString("token", response.data["token"]);
      sp.setString("account", phone);
      Navigator.of(context).pushReplacementNamed(HOME);
    }
  }
}

  
}