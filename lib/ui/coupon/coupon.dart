import 'package:flutter/material.dart';
import 'coupon_description.dart';

class Coupon extends StatefulWidget{
  CouponDescription couponDescription;
  Coupon({this.couponDescription});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CouponState();
  }

}

class CouponState extends State<Coupon> {
  @override
  Widget build(BuildContext context) {
    CouponDescription couponDescription = widget.couponDescription;
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
              flex: 64,
                child: buildCouponDescription(couponDescription), ),
              Expanded(
                  flex: 95,
                  child: buildCouponValidation(couponDescription), ),
            ],
          ),
          Stack(
            children: <Widget>[
              Image.asset("assets/images/coupon_bg_bottom.png"),
              Container(
                  child: Text("说明：优惠券不可叠加使用",style: TextStyle(fontSize: 10,color: Colors.white),),
                  padding: EdgeInsets.only(left: 20.0,top: 2),),
            ],
          )
        ],
      ),
    );
  }

  Widget buildCouponDescription(CouponDescription couponDescription){
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Image.asset("assets/images/coupon_bg_left.png",fit: BoxFit.fitHeight,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(couponDescription.usedAmount,style: TextStyle(fontSize: 40,color: Colors.white),),
              padding: EdgeInsets.only(left: 20.0),),
            Container(
              child: Text("满"+couponDescription.withAmount+"使用",style: TextStyle(fontSize: 10,color: Colors.white)),
              padding: EdgeInsets.only(left: 20.0),),
          ],
        )
      ],
    );
  }

  Widget buildCouponValidation(CouponDescription couponDescription){
    String startTime = couponDescription.validStartTime.split(" ")[0].replaceAll("-", ".");
    String endTime = couponDescription.validEndTime.split(" ")[0].replaceAll("-", ".");
    return Stack(
      alignment: AlignmentDirectional.centerEnd,
      children: <Widget>[
        Image.asset("assets/images/coupon_bg_right.png",fit: BoxFit.fitHeight,),
        Container(
          padding: EdgeInsets.only(right: 8.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text(couponDescription.title,style: TextStyle(fontSize: 20,color: Colors.white),),
                padding: EdgeInsets.only(right: 8.0),),
              Text(startTime+"～"+endTime,style: TextStyle(fontSize: 10,color: Colors.grey))
            ],
          ),
        )
      ],
    );
  }
}