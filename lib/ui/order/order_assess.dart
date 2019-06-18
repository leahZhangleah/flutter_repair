import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:repair_project/http/api_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_project/http/http_address_manager.dart';

class Assess extends StatefulWidget {
  final String ordersNumber, ordersId;

  Assess({this.ordersNumber, this.ordersId});

  @override
  State<StatefulWidget> createState() {
    return new AssessState();
  }
}

class AssessState extends State<Assess> {
  double rating = 0;
  final _assess = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("评价订单"),
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context)),
          centerTitle: true,
          actions: <Widget>[
            GestureDetector(
                onTap: () {
                  if (rating != 0) {
                    ApiRequest().appraiseOrders(context, _assess.text, widget.ordersId, widget.ordersNumber, rating);
                  } else {
                    Fluttertoast.showToast(msg: "请对服务进行评分");
                  }
                },
                child: Center(
                    child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    '发布',
                  ),
                )))
          ],
        ),
        body: Container(
            child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      maxLines: 10,
                      controller: _assess,
                      decoration: new InputDecoration(
                          hintText: "快来写下你对本次服务的评价",
                          border: InputBorder.none,
                          hintStyle:
                              TextStyle(color: Colors.grey[350], fontSize: 18)),
                    ),
                    Divider(
                      height: 20.0,
                      indent: 2.0,
                      color: Colors.grey[400],
                    ),
                    Text(
                      "维修评分",
                      style: TextStyle(fontSize: 20),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: SmoothStarRating(
                          allowHalfRating: false,
                          onRatingChanged: (v) {
                            rating = v;
                            setState(() {});
                          },
                          starCount: 5,
                          rating: rating,
                          size: 40.0,
                          color: Colors.lightBlue,
                          borderColor: Colors.grey[350],
                        ))
                  ],
                ))));
  }
}
