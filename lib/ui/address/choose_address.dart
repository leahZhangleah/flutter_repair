import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_project/entity/address.dart';
import 'package:repair_project/entity/description.dart';
import 'package:repair_project/http/HttpUtils.dart';
import 'package:repair_project/ui/address/add_address.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:repair_project/ui/address/update_address.dart';
import 'package:repair_project/ui/publish_detail.dart';
import 'package:repair_project/widgets/behavior.dart';
import 'package:repair_project/widgets/bottom_button.dart';
import 'package:repair_project/widgets/titlebar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:repair_project/http/http_address_manager.dart';
import 'package:repair_project/http/api_request.dart';

class ChooseAddress extends StatefulWidget {
  final String detail, url;
  final Description description;
  final num classify;
  final bool inPublish;

  ChooseAddress({this.detail, this.url, this.classify, this.description,this.inPublish});

  _ChooseAddressState createState() => _ChooseAddressState();
}

class _ChooseAddressState extends State<ChooseAddress> {
  final _scaffoldState = GlobalKey<ScaffoldState>();
  Size deviceSize;
  BuildContext _context;
  num itemHeight = 80;
  num padingHorzation = 20;
  List<Address> _addresses = [];
  var _addlist;

  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _addlist = _addresslist();
  }

  Future<void> _addresslist() async {
    ResultModel resultModel = await ApiRequest().fetchAddressList(context);
    setState(() {
      _addresses = Address.allFromResponse(resultModel.data.toString());
    });
  }

  Future<void> _addressdel(String id) async {
    ApiRequest().deleteAddress(context,id);
    _addresslist();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    deviceSize = MediaQuery.of(_context).size;
    itemHeight = deviceSize.height / 7;
    padingHorzation = deviceSize.width / 4;
    return Scaffold(
        appBar: PreferredSize(
            child: Titlebar1(
                titleValue: "选择地址",
                actionValue: "添加新地址",
                leadingCallback: () => Navigator.pop(context),
                actionCallback: () => Navigator.push<String>(context,
                        new MaterialPageRoute(builder: (BuildContext context) {
                      return new AddAddress();
                    })).then((_) {
                      _addresslist();
                    })),
            preferredSize: Size.fromHeight(50)),
        body: FutureBuilder(
          builder: buildAddressList,
          future: _addlist, // 用户定义的需要异步执行的代码，类型为Future<String>或者null的变量或函数
        ));
  }

  Widget buildAddressList(BuildContext context,AsyncSnapshot snapshot){
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Text('还没有开始网络请求');
      case ConnectionState.active:
        return Text('ConnectionState.active');
      case ConnectionState.waiting:
        return Center(
          child: CircularProgressIndicator(),
        );
      case ConnectionState.done:
        if (snapshot.hasError){
          return Text('Error: ${snapshot.error}');
        }
        return _addresses.length == 0
            ? noaddress(context)
            : ScrollConfiguration(
            behavior: MyBehavior(),
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: _addresses.length,
                itemBuilder: (context, index) {
                  var address = _addresses[index];
                  return Padding(
                    padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                    child: Slidable(
                      actionExtentRatio: 0.3, //0.5
                      delegate: new SlidableDrawerDelegate(),
                      child: _buildListTile(address,index),
                      secondaryActions: <Widget>[
                        new IconSlideAction(
                          caption: '修改',
                          color: Colors.grey,
                          icon: Icons.border_color,
                          onTap: () =>
                              Navigator.push<String>(context,
                                  new MaterialPageRoute(builder:
                                      (BuildContext context) {
                                    return new UpdateAddress(
                                      name: address.name,
                                      phone: address.phone,
                                      id: address.id,
                                      province: address.province,
                                      city: address.city,
                                      district: address.district,
                                      detailedAddress:
                                      address.detailedAddress,
                                      defaultAddress:
                                      address.defaultAddress,
                                    );
                                  })).then((_) {
                                _addresslist();
                              }),
                        ),
                        new IconSlideAction(
                          caption: '删除',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () => _addressdel(address.id),
                        ),
                      ],
                    ),
                  );
                }),
          );
      default:
        Fluttertoast.showToast(msg: "请检查网络连接状态！");
    }
  }

  Widget _buildListTile(Address address,int index){
    return Container(
      child: ListTile(
        onTap:
            widget.inPublish?(){
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (c) {
                return new Detail(
                    detail: widget.detail,
                    url: widget.url,
                    classify: widget.classify,
                    address: address,
                    description: widget.description);
              },
            ),
          );
        }: null,
        title: Row(
          children: <Widget>[
            index==0?
                Text('默认',style: TextStyle(color: Colors.amberAccent),):Container(),
            Text(address.name,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16)),
            Padding(
              padding: EdgeInsets.only(left: 10),
            ),
            Text(address.phone,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16))
          ],
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 4),
          child: address.province == address.city
              ? Text(
              address.province +
                  address.district +
                  address.detailedAddress,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14))
              : Text(
              address.province +
                  address.city +
                  address.district +
                  address.detailedAddress,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14)),
        ),
        contentPadding:
        EdgeInsets.only(left: 10, right: 15),
      ),
        decoration: new BoxDecoration(
            border: new Border(
                bottom: new BorderSide(color: Colors.black12,width: 2.0)
            )
        )
    );
  }

  @override
  Widget noaddress(BuildContext context) {
    itemHeight = MediaQuery.of(context).size.height/7;
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (context){
                  return new AddAddress();
                })
        ).then((_) {
          _addresslist();
        });
      },
      child: new Container(
        //color: Colors.white,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        height: itemHeight,
        child:Center(
          //alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.location_on,color: Colors.blue[400],size: 30,),
              Text('点击添加地址',style: TextStyle(color: Colors.grey,fontSize: 26),)
            ],
          ),
        ),
      ),
    );
  }
}
