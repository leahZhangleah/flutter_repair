import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_project/http/HttpUtils.dart';
import 'package:repair_project/logic/viewmodel/personal_view_model.dart';
import 'package:repair_project/model/personalmodel.dart';
import 'package:repair_project/ui/address/addressmanager.dart';
import 'package:repair_project/ui/address/choose_address.dart';
import 'dart:convert';
import 'package:repair_project/ui/coupon/coupon.dart';
import 'package:repair_project/ui/coupon/coupon_list.dart';
import 'package:repair_project/ui/login/register.dart';
import 'package:repair_project/ui/order/orderhis.dart';
import 'package:repair_project/ui/pay/pay_page.dart';
import 'package:repair_project/ui/personal_info/personal.dart';
import 'package:repair_project/ui/personal_info/base_provider.dart';
import 'package:repair_project/ui/personal_info/change_personal_info_bloc.dart';
import 'package:repair_project/ui/personal_info/repairuser_db.dart';
import 'package:repair_project/widgets/behavior.dart';
import 'package:repair_project/ui/feedback.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:repair_project/http/http_address_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MineState();
  }
}

class MineState extends State<MinePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  num padingHorzation = 20;
  Size deviceSize;
  /*String name, image = "";
  var getInfo;
*/
  RepairUserDB repairUserDB;
  ChangePersonalInfoBloc changePersonalInfoBloc;
  @override
  void initState() {
    super.initState();
    //getInfo = getPersonalInfo();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    changePersonalInfoBloc = Provider.of<ChangePersonalInfoBloc>(context);
    changePersonalInfoBloc.getPersonalInfo(context);
  }

  @override
  Widget build(BuildContext context) {
    PersonalViewMModel vm = PersonalViewMModel();
    List<PersonalModel> data = vm.getPersonalItems();
    deviceSize = MediaQuery.of(context).size;
    padingHorzation = deviceSize.width / 4;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        flexibleSpace: Container(
          color: Colors.lightBlue,
        ),
        bottom: PreferredSize(
            child: Container(
              height: 100,
              child: StreamBuilder(
                  stream: changePersonalInfoBloc.repairUserDB,
                  builder: (context,AsyncSnapshot<RepairUserDB> snapshot){
                    if(snapshot.hasData){
                      repairUserDB = snapshot.data;
                      return buildPersonalLine(repairUserDB);
                    }else if(snapshot.hasError){
                      return _buildErrorWidget(snapshot.error);
                    }else{
                      return _buildLoadingWidget();
                    }
                  }),
            ),
            preferredSize: Size(30, 80)),
      ),
      body: Column(
        children: <Widget>[
          ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView.builder(
                  itemCount: data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return buildAddressLine(index, data);
                  })),
          Center(
            child: Container(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                "Copyright©2019-2029\n上海允宜实业发展有限公司",
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildPersonalLine(RepairUserDB repairUserDB) {
    if(repairUserDB==null){
      return new Text("无法获取用户信息");
    }
    return new Container(
        color: Colors.lightBlue,
        padding: EdgeInsets.only(left: 10, bottom: 10),
        height: 100,
        child: Center(
          child: ListTile(
            leading: ClipRRect(
              borderRadius: new BorderRadius.circular(8.0),
              child: Container(
                  width: 75.0,
                  height: 75.0,
                  child: buildImgWidget(repairUserDB.headimg)
              ),
            ),
            title: Text(
              repairUserDB.name,
              style: TextStyle(
                  letterSpacing: 5, fontSize: 20, color: Colors.white),
            ),
            trailing: Icon(
              Icons.chevron_right,
              size: 40,
            ),
            onTap: () {
              Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (c) {
                    return Personal(); //todo go to personal setting page //repairUserDB: repairUserDB,
                  },
                ),
              )
              /*.then((_) {
                getPersonalInfo();
              })*/;
            },
          ),
        ));
  }

  Widget  buildImgWidget(String imgUrl){
    if(imgUrl.startsWith("assets")){
      return Image.asset(imgUrl,fit: BoxFit.fill,);
    }else if(imgUrl.startsWith("/upload")){
      String fileUploadServer = HttpAddressMananger().fileUploadServer;
      String networkImgUrl = fileUploadServer+imgUrl;
      CachedNetworkImage cachedNetworkImage = CachedNetworkImage(
        fit: BoxFit.fill,
        imageUrl: networkImgUrl,
        placeholder: (context,text)=>new CircularProgressIndicator(),
        errorWidget: (context,text,object)=>new Icon(Icons.error),
      );
      //updateImgPathInDB(networkImgUrl,cachedNetworkImage.cacheManager);
      return cachedNetworkImage;
    }else{//todo: if the data is from DB, and the image path is from cache, it could be GCed and invalid, make judgement here to decide if it's from cache or from file
      //return Image.asset(imgUrl);
      return Image.file(new File(imgUrl),fit: BoxFit.fill,);
    }
  }

  Widget _buildErrorWidget(error) {
    return Center(
      child:Text("错误：$error"),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('加载中...'),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget buildAddressLine(index, datas) {
    PersonalModel model = datas[index];
    return Container(
        color: Colors.white,
        height: 60,
        child: Column(children: <Widget>[
          Center(
            child: ListTile(
              leading: Icon(model.leadingIcon),
              title: Text(model.text),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.grey[400],
              ),
              onTap: () {
                index == 0
                    ? Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (c) {
                      return new ChooseAddress(inPublish: false,);
                    },
                  ),
                )
                    : index == 1
                    ? Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (c) {
                      return new CouponList();
                    },
                  ),
                )
                    : index == 2
                    ? Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (c) {
                      return new OrderHistory();
                    },
                  ),
                )
                    : index == 3
                    ? showDialog<bool>(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: CupertinoDialogAction(
                        child: Text(
                          "客服电话",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      ),
                      content: CupertinoDialogAction(
                        child: Text(
                          "400-400-400",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      ),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          onPressed: () async {
                            Navigator.pop(context);
                            const tel = 'tel:10086';
                            if (await canLaunch(tel)) {
                              await launch(tel);
                            } else {
                              throw 'Could not launch $tel';
                            }
                          },
                          child: Container(
                            child: Text(
                              "确定",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        CupertinoDialogAction(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            child: Text(
                              "取消",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                )
                    : Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (c) {
                      return new FeedBack();
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            child: Divider(height: 3, color: Colors.grey[300]),
            margin: EdgeInsets.only(left: 15, right: 15),
          )
        ]));
  }
}
