import 'package:flutter/material.dart';
import 'package:repair_project/widgets/titlebar.dart';
import 'coupon_description.dart';
import 'package:repair_project/http/HttpUtils.dart';
import 'dart:convert';
import 'coupon_response.dart';
import 'coupon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:repair_project/http/http_address_manager.dart';
import 'package:repair_project/http/api_request.dart';

class CouponList extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CouponListState();
  }
}

class CouponListState extends State<CouponList> {
  List<CouponDescription> couponList;
  var cList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cList = ApiRequest().fetchValidCouponList();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: PreferredSize(child: Titlebar1(
          titleValue: "优惠券",
          leadingCallback: ()=>Navigator.pop(context),),
          preferredSize: Size.fromHeight(50)),
      body: Container(
        child: FutureBuilder(
          future: cList,
            builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.done){
              if(snapshot.hasData){
                couponList = snapshot.data;
                return ListView.builder(
                    itemCount: couponList.length,
                    itemBuilder: (context,index){
                      return Coupon(couponDescription: couponList[index],);
                    });
              }else{
                //todo: the data fetched from internet is null
                return new Container();
              }
            }else if(snapshot.connectionState==ConnectionState.waiting){
              return new Container(
                child: Center(
                    child:CircularProgressIndicator()
                ),
              );
            }else if(snapshot.connectionState == ConnectionState.none){
              //todo: show a toast
              return Text("请检查网络");
            }
            }),
      )
    );
  }
}