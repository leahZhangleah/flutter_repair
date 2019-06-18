import 'package:city_picker/city_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:repair_project/http/http_address_manager.dart';

class UpdateAddress extends StatefulWidget {
  final String name, phone, province, city, district, detailedAddress,id;
   int defaultAddress;
  UpdateAddress(
      {this.name,
      this.phone,
      this.province,
      this.city,
      this.district,
      this.detailedAddress,
        this.id,
      this.defaultAddress});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UpdateAddressState();
  }
}

class UpdateAddressState extends State<UpdateAddress> {
  String text = "";
  String p1;
  String p2;
  String p3;
  TextEditingController _phone, _name, _province, _address;
 // bool check = false;
  int da = 0;
  var check = [false,true];
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

  void getHttp(int da) async {
    if(p2==""){
      p2=p1;
    }
    if(_phone.text.length!=11){
      Fluttertoast.showToast(msg: "请填写正确的电话号码");
      return;
    }
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    Options options = new Options();
    options.headers={"token":token};

    try {

      p1==null?p1=widget.province:p1;
      p2==null?p2=widget.city:p2;
      p3==null?p3=widget.district:p3;

      Response response = await Dio().post(HttpAddressMananger().getUpdateAddress(),
          options: options,
          data: {'city':'$p2','defaultAddress':da,
            'id':widget.id,
            'description':_name.text+_phone.text+_province.text+_address.text,
            'detailedAddress':_address.text,'district':'$p3','name':_name.text,
            'phone':_phone.text,'province':'$p1'});
      print(response);
    } catch (e) {
      print(e);
    }
    Fluttertoast.showToast(msg: "修改成功");
    Navigator.of(context).pop();
  }

  void initState() {
    _name = new TextEditingController.fromValue(
        new TextEditingValue(text: widget.name));
    _phone = new TextEditingController.fromValue(
        new TextEditingValue(text: widget.phone));
    _province = new TextEditingController.fromValue(new TextEditingValue(
        text: widget.province == widget.city
            ? widget.province + widget.district
            : widget.province + widget.city + widget.district));
    _address = new TextEditingController.fromValue(
        new TextEditingValue(text: widget.detailedAddress));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("修改地址"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)),
        centerTitle: true,
        actions: <Widget>[
          GestureDetector(
              onTap: () {
                if (_name.text == '' ||
                    _phone.text == '' ||
                    _province.text == '' ||
                    _address.text == '') {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          new AlertDialog(title: new Text("请把信息填写完整")));
                  return;
                }
                getHttp(da);
              },
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: TextField(
                                controller: _name,
                                decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "添加人",
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
                                    hintText: "添加人电话号码",
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
                                    hintText: "添加人地区",
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
                            padding: EdgeInsets.only(left: 15, right: 15, top:50,bottom: 5),
                            child: Row(
                              children: <Widget>[
                                Text("是否设为默认地址"),
                                Switch(
                                  value: check[widget.defaultAddress],
                                  activeColor: Colors.blue, // 激活时原点颜色
                                  onChanged: (val) {
                                    this.setState(() {
                                      check[widget.defaultAddress]=val;
                                      val?da=1:da=0;
                                      print(da);
                                    });
                                  },
                                )
                              ],
                            ))
                      ],
                    )),
                Expanded(
                  flex: 5,
                  child: Container(),
                ),
              ],
            )),
      ),
    );
  }
}
