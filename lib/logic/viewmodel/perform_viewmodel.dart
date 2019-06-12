import 'package:flutter/material.dart';
import 'package:repair_project/model/menu.dart';

class PerformViewModel{

  List<Menu> menuItems;

  PerformViewModel({this.menuItems});

  getMenuItems(){
    return menuItems = <Menu>[
      Menu(
       // title: "",
       // icon: Icons.format_italic,
        menuColor: Colors.white,
        image: "images/test.png",
      ),
    ];
  }

}