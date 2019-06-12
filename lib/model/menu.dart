import 'package:flutter/material.dart';

class Menu{
  String title;
  IconData icon;
  String image;
  BuildContext mContext;
  Color menuColor;

  Menu({this.title,
    this.icon,
    this.image,
    this.mContext,
    this.menuColor = Colors.blue
  });


}