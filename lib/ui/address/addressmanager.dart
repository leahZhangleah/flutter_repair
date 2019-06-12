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

class AddressManager extends StatefulWidget {

  AddressManagerState createState() => AddressManagerState();
}

class AddressManagerState extends State<AddressManager> {
  final _scaffoldState = GlobalKey<ScaffoldState>();
  Size deviceSize;
  BuildContext _context;
  num itemHeight = 80;
  num padingHorzation = 20;
  List<Address> _addresses = [];
  var _addlist;

  void initState() {
    super.initState();
    _addlist=_addresslist();
  }

  Future<void> _addresslist() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    RequestManager.baseHeaders={"token": token};
    ResultModel response = await RequestManager.requestGet("/repairs/repairsUserAddress/listAll",null);
    print(response.toString());
    setState(() {
      _addresses = Address.allFromResponse(response.data.toString());
    });
  }

  Future<void> _addressdel(String id) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    RequestManager.baseHeaders={"token": token};
    List<String> ids = new List<String>();
    ids.add(id);
    await RequestManager.requestPost("/repairs/repairsUserAddress/delete",ids);
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
                titleValue: "我的地址",
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
          builder: _buildFuture,
          future: _addlist, // 用户定义的需要异步执行的代码，类型为Future<String>或者null的变量或函数
        ));
  }

  ///snapshot就是_calculation在时间轴上执行过程的状态快照
  Widget _buildFuture(BuildContext context, AsyncSnapshot snapshot) {
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
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        return _addresses.length==0?noaddress(context)
            :Column(
          children: <Widget>[
            buildCurrentAddress(),
            Expanded(
              flex: 1,
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: _addresses.length-1,
                    itemBuilder: (context, index) {
                      var address = _addresses[index+1];
                      return Padding(
                        padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                        child: Column(
                          children: <Widget>[
                            Slidable(
                              actionExtentRatio: 0.5,
                              delegate: new SlidableDrawerDelegate(),
                              child: ListTile(
                                title: Row(
                                  children: <Widget>[
                                    Text(address.name,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16)),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                    ),
                                    Text(address.phone,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16))
                                  ],
                                ),
                                subtitle: Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: address.province==address.city?Text(
                                      address.province +
                                          address.district +
                                          address.detailedAddress,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14)):
                                  Text(address.province+address.city+address.district+address.detailedAddress,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14)),
                                ),
                                contentPadding:
                                EdgeInsets.only(left: 10, right: 15),
                              ),
                              secondaryActions: <Widget>[
                                new IconSlideAction(
                                  caption: '修改',
                                  color: Colors.grey,
                                  icon: Icons.border_color,
                                  onTap: () =>Navigator.push<String>(
                                      context,new MaterialPageRoute(builder: (BuildContext context){
                                    return new UpdateAddress(name:address.name,phone:address.phone,id:address.id,
                                      province:address.province,city:address.city,
                                      district:address.district,detailedAddress:address.detailedAddress,defaultAddress: address.defaultAddress,);
                                  })
                                  ).then((_) {
                                    _addresslist();
                                  }),
                                ),
                                new IconSlideAction(
                                  caption: '删除',
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: ()=>_addressdel(address.id),
                                ),
                              ],
                            ),
                            index < 10
                                ? Container(
                                margin:
                                EdgeInsets.only(left: 15, right: 15),
                                child:
                                Divider(height: 1, color: Colors.grey))
                                : null,
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ],
        );
      default:
        Fluttertoast.showToast(msg: "请检查网络连接状态！");
    }
  }


  Widget buildCurrentAddress() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 1),
    child: Slidable(
    actionExtentRatio: 0.5,
    delegate: new SlidableDrawerDelegate(),
          child: ListTile(
            leading: Icon(
              Icons.location_on,
              color: Colors.blue[400],
              size: 40,
            ),
            title: Row(
              children: <Widget>[
                Text(_addresses[0].name, style: TextStyle(color: Colors.black, fontSize: 14)),
                SizedBox(width: 5),
                Text(_addresses[0].phone,
                    style: TextStyle(color: Colors.black, fontSize: 14))
              ],
            ),
            subtitle: _addresses[0].province == _addresses[0].city
                ? Text(
                _addresses[0].province +
                    _addresses[0].district +
                    _addresses[0].detailedAddress,
                style: TextStyle(color: Colors.black, fontSize: 14))
                : Text(
                _addresses[0].province +
                    _addresses[0].city +
                    _addresses[0].district +
                    _addresses[0].detailedAddress,
                style: TextStyle(color: Colors.black, fontSize: 14)),
          ),
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
                      name: _addresses[0].name,
                      phone: _addresses[0].phone,
                      id: _addresses[0].id,
                      province: _addresses[0].province,
                      city: _addresses[0].city,
                      district: _addresses[0].district,
                      detailedAddress:
                      _addresses[0].detailedAddress,
                      defaultAddress:
                      _addresses[0].defaultAddress,
                    );
                  })).then((_) {
                _addresslist();
              }),
        ),
        new IconSlideAction(
          caption: '删除',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _addressdel(_addresses[0].id),
        ),
      ],
    )
        ),
        Container(
          height: 15,
          color: Colors.grey[300],
        )
      ],
    );
  }
  
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
              Icon(Icons.location_on,color: Colors.blue[400],size: 50,),
              Text('点击添加地址',style: TextStyle(color: Colors.grey,fontSize: 26),)
            ],
          ),
        ),
      ),
    );
  }
}
