import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyBehavior extends ScrollBehavior{
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    if(defaultTargetPlatform==TargetPlatform.android||defaultTargetPlatform==TargetPlatform.fuchsia){
      return child;
    }else{
      return super.buildViewportChrome(context,child,axisDirection);
    }
  }
}