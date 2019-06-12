import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:city_picker/city_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:repair_project/http/http_address_manager.dart';

class AddAddress extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddAddressState();
  }
}

class AddAddressState extends State<AddAddress> {
  String text = "";
  String p1;
  String p2;
  String p3;
  bool check = false;
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _province = TextEditingController();

  void _incrementCounter() async {
    CityResult result = await showCityPicker(context,
        initCity: CityResult()
          ..province = p1
          ..city = p2
          ..county = p3);

    if (result == null) {
      return;
    }

    p1 = result?.province;
    p2 = result?.city;
    p3 = result?.county;

    if (p2 == "市辖区") {
      p2 = "";
    }

    if (p3 == "市辖区") {
      Fluttertoast.showToast(msg: "请选择所在区");
      return;
    }

    setState(() {
      _province.text = "${p1}${p2}${p3}";
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void getHttp() async {
    if (p2 == "") {
      p2 = p1;
    }
    if (_phone.text.length != 11) {
      Fluttertoast.showToast(msg: "请填写正确的电话号码");
      return;
    }
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    Options options = new Options();
    options.headers = {"token": token};
    try {
      Response response = await Dio().post(
          HttpAddressMananger().getSaveNewAddress(),
          options: options,
          data: {
            'city': '$p2',
            'defaultAddress': check?1:0,
            'description':
                _name.text + _phone.text + _province.text + _address.text,
            'detailedAddress': _address.text,
            'district': '$p3',
            'name': _name.text,
            'phone': _phone.text,
            'province': '$p1'
          });
      print(response);
    } catch (e) {
      print(e);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("添加新地址"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)),
        centerTitle: true,
        actions: <Widget>[
          GestureDetector(
              onTap: getHttp,
              child: Center(
                  child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text(
                  '保存',
                ),
              )))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            decoration: BoxDecoration(color: Colors.grey[300]),
            child: Column(
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: TextField(
                                controller: _name,
                                decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "联系人",
                                    hintStyle: TextStyle(
                                        color: Colors.grey[200], fontSize: 18)))),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Divider(
                            height: 2,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: TextField(
                                controller: _phone,
                                keyboardType: TextInputType.number,
                                decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "联系人电话号码",
                                    hintStyle: TextStyle(
                                        color: Colors.grey[200], fontSize: 18)))),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Divider(
                            height: 2,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: TextField(
                                controller: _province,
                                onTap: _incrementCounter,
                                decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "联系人地区",
                                    hintStyle: TextStyle(
                                        color: Colors.grey[200], fontSize: 18)))),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Divider(
                            height: 2,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                            padding:
                                EdgeInsets.only(left: 15, right: 15, bottom: 5),
                            child: TextField(
                                controller: _address,
                                decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "详细地址：如道路、门牌号、小号、楼栋号等",
                                    hintStyle: TextStyle(
                                        color: Colors.grey[200], fontSize: 18)))),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Divider(
                            height: 2,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 15, right: 15, top: 50, bottom: 5),
                            child: Row(
                              children: <Widget>[
                                Text("是否设为默认地址"),
                                Switch(
                                  value: this.check,
                                  activeColor: Colors.blue, // 激活时原点颜色
                                  onChanged: (bool val) {
                                    this.setState(() {
                                      this.check = !this.check;
                                    });
                                  },
                                )
                              ],
                            ))
                      ],
                    )),
              ],
            )),
      ),
    );
  }
}
