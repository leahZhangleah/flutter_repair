import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:repair_project/http/http_address_manager.dart';
import 'base_provider.dart';
import 'change_personal_info_bloc.dart';

class Name extends StatefulWidget {

  final String name,id,userId;
  Name({this.name,this.id,this.userId});

  @override
  State<StatefulWidget> createState() {
    return new NameState();
  }
}

class NameState extends State<Name> {
  TextEditingController _controller;
  ChangePersonalInfoBloc personalInfoBloc;

  void initState(){
    _controller =new TextEditingController.fromValue(
        new TextEditingValue(text: widget.name));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    personalInfoBloc = Provider.of<ChangePersonalInfoBloc>(context);
  }

  Future updatePersonalInfo() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    Options options = new Options();
    options.headers = {"token": token};
    try {
      Response response = await Dio().post(
          HttpAddressMananger().getUpdatePersonalInfoUrl(),
          options: options,
          data: {
            'id':widget.id,
            'name':_controller.text
          });
      print(response);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("修改名字"),
          leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=>Navigator.pop(context,_controller.text)),
          centerTitle: true,
          actions: <Widget>[
            GestureDetector(
                onTap: (){
                  if (_controller.text == '') {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => new AlertDialog(title: new Text("请输入昵称") ));
                    return;
                  }
                  //updatePersonalInfo();
                  personalInfoBloc.updateName(widget.id, widget.userId,_controller.text);
                  Navigator.pop(context,_controller.text);
                },
                child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        '确定',
                      ),
                    )))
          ],
        ),
        body: Container(
            decoration: BoxDecoration(color: Colors.grey[300]),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(padding: EdgeInsets.only(left: 10),
                      child:TextField(
                          controller: _controller,
                          decoration: new InputDecoration(
                              border: InputBorder.none,
                              hintText: "用户名",
                              hintStyle: TextStyle(color:Colors.grey[200],fontSize: 22)
                          )
                      )
                  ),
                )
              ],
            ))
    );
  }
}
