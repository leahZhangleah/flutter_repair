import 'package:flutter/material.dart';

class Titlebar1 extends PreferredSize {
  String titleValue;
  String actionValue;
  VoidCallback leadingCallback, actionCallback;
  Widget child;
  Widget bottomView;

  Titlebar1(
      {@required this.titleValue,
      this.actionValue,
      this.leadingCallback,
      this.actionCallback,
      this.bottomView});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: 30,
          ),
          onPressed: leadingCallback),
      title: Text(
        titleValue,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      actions: actionValue!=null?<Widget>[
        FlatButton(
          padding: EdgeInsets.only(left: 0, right: 0),
          color: Colors.blue,
          child: Text(
            actionValue,
            style: TextStyle(
                color: Colors.white,fontStyle: FontStyle.normal),
          ),
          onPressed: actionCallback,
        ),
      ]:null,
      bottom: bottomView,
    );
  }
}

class SimpleAppBar extends PreferredSize {
  String titleValue;
  String actionValue;
  Widget child;
  Widget bottomView;

  SimpleAppBar({@required this.titleValue,this.actionValue});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        titleValue,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      centerTitle: true,
    );
  }
}

class MainAppBar extends PreferredSize {

  String titleValue;
  VoidCallback actionCallback;

  MainAppBar({@required this.titleValue,this.actionCallback});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        titleValue,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      actions: <Widget>[
        GestureDetector(
          child: Container(
            padding: EdgeInsets.only(right: 10),
              color: Colors.blue,
          ),
        )
      ]
    );
  }
}

