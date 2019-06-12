import 'package:flutter/material.dart';
import 'package:repair_project/widgets/titlebar.dart';

class TakePhoto extends StatelessWidget {
  num deviceWidth;
  num deviceHeight;

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    deviceWidth = deviceSize.width;
    deviceHeight = deviceSize.height;

    return Material(
        child: Scaffold(
      appBar: PreferredSize(
          child: Titlebar1(
              titleValue: "修一修",
              actionValue: "...",
              leadingCallback:()=>Navigator.of(context).pop("abc"),
              actionCallback: null),
          preferredSize: Size.fromHeight(50)),
      body: Container(
          color: Colors.grey[300],
          width: deviceWidth,
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              SizedBox(height: 15),
            ],
          )),
    ));
  }
}
