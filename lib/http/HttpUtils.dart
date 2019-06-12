import 'dart:collection';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_project/http/http_address_manager.dart';
import 'package:repair_project/ui/login/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestManager {
  static String baseUrl = HttpAddressMananger().domain;

  static Map<String, String> baseHeaders = {};

  static const CONNET_TYPE_JSON = "application/json";
  static const CONNET_TYPE_FORM = "application/x-www-form-urlencoded";

  static final Map optionParams = {
    "timeMs": 15000,
    "token": null,
    "authorizationCode": null
  };

  static requestPost(url, params, {noTip = false}) async {

    Options options = Options(method: "post");
    print(params);
    return await _requestBase(url, params, baseHeaders, options, noTip: noTip);
  }

  static Future<bool> hasInternet()async{
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: "请检查网络连接");
      return false;
    }
  }

  static requestGet(url,params,{noTips = false}) async {
    Options options = Options(method: "get");
    ResultModel resultModel = await _requestBase(url, params, baseHeaders, options);
    return resultModel;
  }

  static _requestBase(url, params, Map<String, String> header, Options options,
      {noTip = false}) async {
    bool internet = await hasInternet();
    if(!internet){
      return ResultModel(
          ResultErrorEvent(HttpResultCode.NETWORK_ERROR, "请检查网络连接"),
          false,
          HttpResultCode.NETWORK_ERROR);
    }

    Map<String, String> headers = HashMap();
    if (header != null) {
      headers.addAll(header);
    }
    if (options != null) {
      options.headers = headers;
    } else {
      options = Options(method: "get", headers: headers);
    }
    options.baseUrl = baseUrl;
    options.connectTimeout = 15000;
    var dio = Dio();
    Response response;
    try {
      response = await dio.request(url, data: params, options: options);
    } on DioError catch (error) {
      Response errorResponse =
          error.response != null ? error.response : Response(statusCode: 666);
      if (error.type == DioErrorType.CONNECT_TIMEOUT) {
        errorResponse.statusCode = HttpResultCode.NETWORK_TIMEOUT;
      }
      if (Config.debug) {
        print('请求异常: ' + error.toString());
        print('请求异常url: ' + url);
        print('请求头: ' + options.headers.toString());
        print('method: ' + options.method);
      }
      return ResultModel(
          HttpResultCode.errorHandleFunction(
              errorResponse.statusCode, error.message, noTip),
          false,
          errorResponse.statusCode);
    }
    if (Config.debug) {
      print('请求url: ' + url);
      print('请求头: ' + options.headers.toString());
      if (params != null) {
        print('请求参数: ' + params.toString());
      }
      if (response != null) {
        print('返回参数: ' + response.toString());
      }
    }
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResultModel(response, true, HttpResultCode.SUCCESS);
      }
    } catch (error) {
      print(error.toString() + url);
      return ResultModel(response, false, response.statusCode,
          headers: response.headers);
    }
    return ResultModel(
        HttpResultCode.errorHandleFunction(response.statusCode, "", noTip),
        false,
        response.statusCode);
  }
}


Future<bool> checkResponseValidation(BuildContext context,Response response)async {
  var json = jsonDecode(response.toString());
  if(!json['state']){
    
    Fluttertoast.showToast(msg: "登录信息已失效，请重新登录");
    SharedPreferences sp = await SharedPreferences.getInstance();
    String account = sp.getString("account");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) =>new RegisterScreen(account)),
        ModalRoute.withName('/'));
    return false;
  }else{
    return true;
  }
}


class HttpResultCode {
  static const NETWORK_ERROR = -1; //网络错误
  static const NETWORK_TIMEOUT = -2; //网络超时
  static const NETWORK_JSON_EXCEPTION = -3;

  ///网络返回数据格式化一次
  static const SUCCESS = 200;

  static final EventBus eventBus = EventBus();

  static errorHandleFunction(code, msg, noTip) {
    if (!noTip) {
      eventBus.fire(ResultErrorEvent(code,msg));
    }
    return msg;
  }
}

class ResultErrorEvent {
  final int code;
  final String msg;

  ResultErrorEvent(this.code, this.msg);
}

class Config {
  static final debug = true;
}

class ResultModel {
  var data;
  bool success;
  int code;
  var headers;

  ResultModel(this.data, this.success, this.code, {this.headers});
}
