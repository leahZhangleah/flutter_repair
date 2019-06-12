import 'package:flutter/material.dart';

enum DataSource{SELECTED,UNSELECTED}

class ButtonModel{

  Map<DataSource,String> contents;
  Map<DataSource,Color> textColors;
  Map<DataSource,Color> backgroudColors;
  DataSource state;
  String content;
  Color color;
  Color backgroundColor;

  ButtonModel(){
    this.contents = Map();
    this.contents[DataSource.UNSELECTED] = "取消订单";
    this.contents[DataSource.SELECTED] = "已取消";

    this.textColors = Map();
    this.textColors[DataSource.UNSELECTED] = Colors.black;
    this.textColors[DataSource.SELECTED] = Colors.white;

    this.backgroudColors = Map();
    this.backgroudColors[DataSource.UNSELECTED] = Colors.white;
    this.backgroudColors[DataSource.SELECTED] = Colors.grey[400];
  }

  ButtonModel getInstance(state){
    return null;
  }

}