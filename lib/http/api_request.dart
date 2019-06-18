
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
  Future<List<CouponDescription>> fetchUsableCouponList(BuildContext context,double orderAmount) async {
    //todo: figure out parameters needed for coupon list request
    bool internet = await RequestManager.hasInternet();
    if(internet){
      try{
        String token = await getToken();
        RequestManager.baseHeaders = {"token": token};
        String couponListUrl = HttpAddressMananger().usableCouponList;
        ResultModel resultModel = await RequestManager.requestGet(couponListUrl, {'orderAmount':orderAmount});
        bool valid = await handleResultModel(context, resultModel);
        if(valid){
          var json = jsonDecode(resultModel.data.toString());
          return CouponResponse.fromJson(json).couponList;
        }
      }on DioError catch(e){
        handleDioError(e);
      }
    }
  }


  Future<List<CouponDescription>> fetchValidCouponList(BuildContext context) async{
    //todo: figure out parameters needed for coupon list request
    bool internet = await RequestManager.hasInternet();
    if(internet) {
      try{
        String token = await getToken();
        RequestManager.baseHeaders = {"token": token};
        String couponListUrl = HttpAddressMananger().validCouponList;
        ResultModel resultModel = await RequestManager.requestGet(
            couponListUrl, null);
        bool valid = await handleResultModel(context, resultModel);
        if(valid){
          var json = jsonDecode(resultModel.data.toString());
          return CouponResponse
              .fromJson(json)
              .couponList;
        }
      }on DioError catch(e){
        handleDioError(e);
      }

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
      bool internet = await RequestManager.hasInternet();
      if(internet){
        try{
          String token = await getToken();
          RequestManager.baseHeaders = {"token": token};
          ResultModel resultModel = await RequestManager.requestGet(HttpAddressMananger().wxPay, {
            'tradeType': 'APP',
            'repairsOrdersId': orderId,
            'body': "修宜修-首付服务费",
            'totalPrice': (20-couponValue)<=0?0.01:(20-couponValue),
            'paymentType': 0,
            'couponUserId': couponId
          });
          print(resultModel.data.toString());
          //todo:{"msg":"获取预支付交易会话标识失败","code":500,"state":false}
          bool valid = await handleResultModel(context, resultModel);
          if(valid){
            Payment payment = Payment.allFromResponse(resultModel.data.toString());
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
                  _payMoneyForService(context,orderId);
                  Navigator.of(context).pushAndRemoveUntil(
                      new MaterialPageRoute(
                          builder: (context) => new Main(tabindex: 1)),
                          (route) => route == null);
                }
              });
            });
          }
        }on DioError catch(e){
          handleDioError(e);
        }

      }
    }else{
      Fluttertoast.showToast(msg: "请选择支付方式");
    }

  }

  void _payMoneyForService(BuildContext context,String id) async {
    try{
      String token = await getToken();
      RequestManager.baseHeaders = {"token": token};
      ResultModel resultModel = await RequestManager.requestPost(
          HttpAddressMananger().publishedOrder+id, null);
      bool valid = await handleResultModel(context, resultModel);
      if(valid){
        print(resultModel.data.toString());
      }
    }on DioError catch(e){
      handleDioError(e);
    }

  }


  Future paySubOrBal(BuildContext context,String orderId, int type,double cost,num couponValue,String couponId) async {
    bool internet = await RequestManager.hasInternet();
    if(internet){
      try{
        String token = await getToken();
        RequestManager.baseHeaders = {"token": token};
        ResultModel resultModel = await RequestManager.requestGet(HttpAddressMananger().wxPay, {
          'tradeType': 'APP',
          'repairsOrdersId': orderId,
          'body': type == 5 ? "修宜修-定金" : "修宜修-尾款",
          'totalPrice': (cost - couponValue) <= 0
              ? 0.01
              : (cost - couponValue),
          'paymentType': type,
          'couponUserId': couponId
        });
        print(resultModel.data.toString());
        bool valid = await handleResultModel(context, resultModel);
        if(valid){
          Payment payment = Payment.allFromResponse(resultModel.data.toString());
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
              if (data.errCode == 0) _payMoneyForSubOrBal(context,type, orderId);
              Navigator.of(context).pushAndRemoveUntil(
                  new MaterialPageRoute(builder: (context) => new Main(tabindex: 1)),
                      (route) => route == null);
            });
          });
        }
      }on DioError catch(e){
        handleDioError(e);
      }
    }

  }

  void _payMoneyForSubOrBal(BuildContext context,int type, String id) async {
    try{
      String token = await getToken();
      RequestManager.baseHeaders = {"token": token};
      if (type == 5) {
        ResultModel resultModel = await RequestManager.requestPost(
            HttpAddressMananger().payEarnest+id, null);
        bool valid = await handleResultModel(context, resultModel);
        if(valid){
          print(resultModel.data.toString());
        }
      } else {
        ResultModel resultModel = await RequestManager.requestPost(
            HttpAddressMananger().finishOrder+id, null);
        bool valid = await handleResultModel(context, resultModel);
        if(valid){
          print(resultModel.data.toString());
        }
      }
    }on DioError catch(e){
      handleDioError(e);
    }

  }
  
  
  
  //todo:address
  Future<ResultModel> fetchAddressList(BuildContext context) async {
    bool internet = await RequestManager.hasInternet();
    if(internet){
      try{
        String token = await getToken();
        RequestManager.baseHeaders = {"token": token};
        ResultModel resultModel = await RequestManager.requestGet(
            HttpAddressMananger().addressList, null); // "/repairs/repairsUserAddress/listAll",
        bool valid = await handleResultModel(context, resultModel);
        if(valid){
          print(resultModel.data.toString());
          return resultModel;
        }
      }on DioError catch(e){
        handleDioError(e);
      }

    }
  }

  Future<void> deleteAddress(BuildContext context, String id) async {
    bool internet = await RequestManager.hasInternet();
    if(internet){
      try{
        String token = await getToken();
        RequestManager.baseHeaders = {"token": token};
        List<String> ids = new List<String>();
        ids.add(id);
        ResultModel resultModel = await RequestManager.requestPost(HttpAddressMananger().addressDelete,ids); //"/repairs/repairsUserAddress/delete",
        bool valid = await handleResultModel(context, resultModel);
        if(valid){
          Fluttertoast.showToast(msg: resultModel.data['msg']);
        }
      }on DioError catch(e){
        handleDioError(e);
      }

    }
  }
  
  
  //todo:order
  //不同类型订单列表
  Future<ResultModel> getOrderListForDiffType(BuildContext context,int nowPage, int limit,String typeList) async {
    bool internet = await RequestManager.hasInternet();
    if(internet){
      try{
        String token = await getToken();
        RequestManager.baseHeaders = {"token": token};
        ResultModel resultModel = await RequestManager.requestGet(
            HttpAddressMananger().orderList,
            {"nowPage": nowPage, "limit": limit, "typeList": typeList});
        bool valid = await handleResultModel(context, resultModel);
        if(valid){
          print(resultModel.data.toString());
          return resultModel;
        }
      }on DioError catch(e){
        handleDioError(e);
      }

    }

  }
  

  //取消订单
  Future<void> cancelOrder(BuildContext context,String id) async {
    try{
      bool internet = await RequestManager.hasInternet();
      if(internet){
        String token = await getToken();
        RequestManager.baseHeaders = {"token": token};
        ResultModel resultModel = await RequestManager.requestPost(
            HttpAddressMananger().closeOrder+id, null);
        bool valid = await handleResultModel(context, resultModel);
        if(valid){
          print(resultModel.data.toString());
          Fluttertoast.showToast(msg: resultModel.data['msg']);
        }
      }
    }on DioError catch(e){
      handleDioError(e);
    }

  }


  //拒绝报价
  Future<void> refuseOrderQuote(BuildContext context,String id) async {
    bool internet = await RequestManager.hasInternet();
    if(internet){
      try{
        String token = await getToken();
        RequestManager.baseHeaders = {"token": token};
        ResultModel resultModel = await RequestManager.requestPost(
            HttpAddressMananger().refuseQuote+id, null);
        bool valid = await handleResultModel(context, resultModel);
        if(valid){
          print("refuse quote" + resultModel.data.toString());
          //todo: toast msg to user to tell if user has refused the quote successfully
          Fluttertoast.showToast(msg: resultModel.data['msg']);
        }
      }on DioError catch(e){
        handleDioError(e);
      }

    }

  }

  //todo:material
  Future<ResultModel> getMaterialList(BuildContext context,int nowPage,int limit) async{
    bool internet = await RequestManager.hasInternet();
    if(internet){
      try{
        String token = await getToken();
        RequestManager.baseHeaders={"token": token};
        ResultModel resultModel = await RequestManager.requestGet(HttpAddressMananger().materialList,{"page": nowPage, "limit": limit});
        bool valid = await handleResultModel(context, resultModel);
        if(valid){
         print(resultModel.data.toString());
         return resultModel;
       }
      }on DioError catch(e){
        handleDioError(e);
      }

    }

  }

  //todo:logout
//todo: dialog to be sure if user wants to log out
  void logout(BuildContext context) async{
    bool internet = await RequestManager.hasInternet();
    if(internet){
      try{
        SharedPreferences sp = await SharedPreferences.getInstance();
        String token = sp.getString("token");
        String account = sp.getString("account");
        RequestManager.baseHeaders={"token": token};
        ResultModel resultModel = await RequestManager.requestPost(HttpAddressMananger().logout,null);
        bool valid = await handleResultModel(context, resultModel);
        if(valid){
          if(json.decode(resultModel.data.toString())["msg"]=="success"){
            sp.remove("token");
            Navigator.of(context).pushAndRemoveUntil(
                new MaterialPageRoute(builder: (context) => new RegisterScreen(account)
                ),  ModalRoute.withName('/'));
          };
        }
      }on DioError catch(e){
        handleDioError(e);
      }

    }

  }


  //todo:login
Future<void> login(BuildContext context,Dio dio,String phone,String capcha) async{
  bool internet = await RequestManager.hasInternet();
  if(internet){
    SharedPreferences sp = await SharedPreferences.getInstance();
    try{
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
    }on DioError catch(e){
      handleDioError(e);
    }

  }

}

  Future<bool> handleResultModel(BuildContext context,ResultModel resultModel)async {
    if(resultModel.success){
      var json = jsonDecode(resultModel.data.toString());
      if(!json['state']){
        /*Fluttertoast.showToast(msg: "登录信息已失效，请重新登录");
      SharedPreferences sp = await SharedPreferences.getInstance();
      String account = sp.getString("account");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) =>new RegisterScreen(account)),
          ModalRoute.withName('/'));*/

        if(json['code']==401){
          Fluttertoast.showToast(msg: json['msg']);
          SharedPreferences sp = await SharedPreferences.getInstance();
          String account = sp.getString("account");
          sp.remove("token");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) =>new RegisterScreen(account)),
              ModalRoute.withName('/'));
        }
        //todo: based on different msg, take different actions
        return false;
      }else{
        return true;
      }
    }else{
      print(resultModel.data.toString()+"request return code: ${resultModel.code}");
      //todo:only for debug
      Fluttertoast.showToast(msg: resultModel.data.toString());
      return false;
    }

  }


  Future<bool> handleResponse(BuildContext context,Response response)async {
    var json = jsonDecode(response.toString());
    if(!json['state']){
      if(json['code']==401){
        Fluttertoast.showToast(msg: json['msg']);
        SharedPreferences sp = await SharedPreferences.getInstance();
        String account = sp.getString("account");
        sp.remove("token");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) =>new RegisterScreen(account)),
            ModalRoute.withName('/'));
      }
      return false;
    }else{
      return true;
    }
  }


  void handleDioError(DioError e){
    if(e.response!=null){
    //错误发生在服务器响应之后
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
    }else{
      print(e.request);
      print(e.message);
    }
}


//todo:appraise
  Future<void> appraiseOrders(BuildContext context, String feedback,String ordersId,String ordersNumber,double rating) async {
    bool internet = await RequestManager.hasInternet();
    if(internet){
      try{
        String token = await getToken();
        Options options = new Options();
        options.headers = {"token": token};
        try {
          Response response = await Dio().post(
              HttpAddressMananger().getSaveAppraiseUrl(),
              options: options,
              data: {
                'content': feedback,
                'ordersId': ordersId,
                'ordersNumber': ordersNumber,
                'starLevel': rating
              });
          bool valid = await handleResponse(context, response);
          if(valid){
            print(response.toString());
            Fluttertoast.showToast(
                msg: json
                    .decode(response.toString())
                    .cast<String, dynamic>()['msg']);
            Navigator.pop(context);
          }

        } catch (e) {
          print(e);
        }
      }on DioError catch(e){
        handleDioError(e);
      }

    }
  }
  
}