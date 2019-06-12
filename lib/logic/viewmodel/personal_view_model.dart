import 'package:flutter/material.dart';
import 'package:repair_project/model/personalmodel.dart';

class PersonalViewMModel {
  List<PersonalModel> items;

  PersonalViewMModel({this.items});

  getPersonalItems() {
    return items = <PersonalModel>[
      PersonalModel(
        leadingIcon: Icons.location_on,
        text: "我的地址",
      ),
      PersonalModel(
        leadingIcon: Icons.shopping_cart,
        text: "优惠券",
      ),
      PersonalModel(
        leadingIcon: Icons.history,
        text: "历史订单",
      ),
      PersonalModel(
        leadingIcon: Icons.headset,
        text: "联系客服",
      ),
      PersonalModel(
        leadingIcon: Icons.message,
        text: "意见反馈",
      ),
    ];
  }
}
