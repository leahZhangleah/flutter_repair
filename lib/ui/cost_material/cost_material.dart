import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_refresh/flutter_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_project/entity/costmaterial.dart';
import 'package:repair_project/http/HttpUtils.dart';
import 'package:repair_project/http/api_request.dart';
import 'package:repair_project/ui/cost_material/cost_material_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:repair_project/http/http_address_manager.dart';

class CostMaterial extends StatefulWidget{
  
  @override
  State<StatefulWidget> createState() {
    return CostMaterialState();
  }
  
}

class CostMaterialState extends State<CostMaterial> with AutomaticKeepAliveClientMixin{

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  int nowPage = 1;
  int limit = 10;
  int total = 0;
  List<MaterialInfo> _materialInfo = [];
  String url = "";
  @override
  void initState() {
    _material(nowPage, limit);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("耗材列表"),
        centerTitle: true,
      ),
      body: Refresh(
      onFooterRefresh: onFooterRefresh,
      onHeaderRefresh: onHeaderRefresh,
      child: ListView.builder(
        shrinkWrap: false,
        itemCount: _materialInfo.length,
        itemExtent: 50.0,
        scrollDirection: Axis.vertical,
        itemBuilder: (context,index){
          var materialInfo = _materialInfo[index];
          return buildItemCost(materialInfo);
        }),
    ));
  }

  //上拉加载更多
  Future<Null> onFooterRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      setState(() {
        nowPage += 1;
        //limit += 10;
        if (_materialInfo.length > total) {
          Fluttertoast.showToast(msg: "没有更多的订单了");
        } else {
          _material(nowPage, limit);
        }
      });
    });
  }

  //下拉刷新
  Future<Null> onHeaderRefresh() {
    return new Future.delayed(new Duration(seconds: 2), () {
      setState(() {
        nowPage = 1;
        limit = 10;
        _material(nowPage, limit);
      });
    });
  }

  Future _material(int nowPage,int limit) async{
    ResultModel resultModel = await ApiRequest().getMaterialList(nowPage, limit);
    print(resultModel.data.toString());
    setState(() {
      _materialInfo = MaterialInfo.allFromResponse(resultModel.data.toString());
      total = json
          .decode(resultModel.data.toString())
          .cast<String, dynamic>()['page']['totalCount'];
      url = json.decode(resultModel.data.toString()).cast<String,dynamic>()['fileUploadServer'];
    });
    print(total);
  }

  Widget buildItemCost(MaterialInfo materialInfo){
    return Container(
      padding: EdgeInsets.only(top:5,left: 15,right: 15),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Image.network(url+materialInfo.picture,height: 70,width: 70,fit: BoxFit.fitHeight,),
            title: Text(materialInfo.name,style: TextStyle(fontSize: 18,letterSpacing:1,fontWeight: FontWeight.w400),),
            onTap: (){
              Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (c) {
                    return new CostMaterialDetails(id:materialInfo.id,name:materialInfo.name,picture:url+materialInfo.picture,description:materialInfo.description);
                  },
                ),
              );
            },
            subtitle: Text(materialInfo.description,maxLines: 3,overflow: TextOverflow.ellipsis,),
            isThreeLine: true,
          ),
          SizedBox(height: 5),
          Divider(height: 2,color: Colors.grey[500])
        ],
      )
    );
  }


  
}