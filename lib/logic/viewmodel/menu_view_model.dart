import 'package:flutter/material.dart';
import 'package:repair_project/model/menu.dart';

class MenuViewMModel{

  List<Menu> menuItems;

  MenuViewMModel({this.menuItems});

  getMenuItems(){
    return menuItems = <Menu>[
      Menu(
        title: "墙面开裂",
        menuColor: Colors.white,
      //  icon: Icons.code,
        image: "",
      ),
      Menu(
        title: "水路维修",
        menuColor: Colors.white,
        icon: Icons.code,
      ),
      Menu(
        title: "电路维修",
        menuColor: Colors.white,
        icon: Icons.code,
        image: "images/avatar.png"
      ),
      Menu(
        title: "其他维修",
        menuColor: Colors.white,
        icon: Icons.code,
        image: "images/avatar.png"
      ),
    ];
  }

}