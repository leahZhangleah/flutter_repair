import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_project/entity/address.dart';
import 'package:repair_project/entity/description.dart';
import 'package:repair_project/ui/MainScreen.dart';
import 'package:repair_project/ui/order/orderlist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:repair_project/http/http_address_manager.dart';
class Detail extends StatefulWidget {
  final String detail, url;
  final Description description;
  final num classify;
  final Address address;

  Detail({this.detail, this.url, this.classify, this.address,this.description});

  @override
  State<StatefulWidget> createState() {
    return DetailState();
  }
}

class DetailState extends State<Detail> {
  VideoPlayerController _videoPlayerController;
  var c = ['墙面开裂', '水路维修', '电路维修', '其他维修'];
  bool initialized = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.file(new File(widget.url));
    _videoPlayerController.initialize().then((value) {
      initialized = true;
      setState(() {});
    });
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  void publish() async {

    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    Options options = new Options();
    options.headers={"token":token};
    try {
      Response response = await Dio().post(HttpAddressMananger().getPublishOrderUrl(),
          options: options,
          data: {'contactsAddress':widget.address.city==widget.address.province?widget.address.province+widget.address.district+widget.address.detailedAddress:widget.address.province+widget.address.city+widget.address.district+widget.address.detailedAddress,
          'contactsName':widget.address.name,
          'contactsPhone':widget.address.phone,
          'description':widget.detail,
          'type':c[widget.classify].toString(),
          'repairsOrdersDescriptionList':[
            {
              "fileName": widget.description.fileName,
              "type": widget.description.type,
              "url": widget.description.url
            }
          ]});
      print(response);
    } catch (e) {
      print(e);
    }

    Fluttertoast.showToast(msg: "发布成功！");

    Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (c) => new Main(tabindex: 1,)
        ), (route) => route == null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
              backgroundColor: Colors.blue,
              centerTitle: true,
              title: Text("确认订单"),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context)))),
      body: SingleChildScrollView(child:Container(
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 20),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        widget.detail==null?Text("暂无文字描述",style: TextStyle(color: Colors.grey,fontSize: 18),):
                        Text(
                          widget.detail,
                          style: TextStyle(fontSize: 18),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _videoPlayerController.value.isPlaying
                                  ? _videoPlayerController.pause()
                                  : _videoPlayerController.play();
                              _videoPlayerController.setLooping(true);
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            child: Stack(
                              alignment: FractionalOffset(0.5, 0.5),
                              children: <Widget>[
                                initialized
                                    ? AspectRatio(
                                        aspectRatio: 0.9,
                                        child:
                                            VideoPlayer(_videoPlayerController),
                                      )
                                    : Container(),
                                _videoPlayerController.value.isPlaying
                                    ? Icon(
                                        Icons.pause_circle_outline,
                                        size: 60,
                                        color: Colors.white30,
                                      )
                                    : Icon(
                                        Icons.play_circle_outline,
                                        size: 60,
                                        color: Colors.white30,
                                      )
                              ],
                            ),
                          ),
                        ),
                        Text(
                          '#' + c[widget.classify],
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                )),
            Padding(
                padding: EdgeInsets.only(top: 15),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(widget.address.name,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16)),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                            ),
                            Text(widget.address.phone,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16))
                          ],
                        ),
                        widget.address.city==widget.address.province?Text(widget.address.province+widget.address.district+widget.address.detailedAddress,
                        style: TextStyle(fontSize: 16),)
                        :Text(widget.address.province+widget.address.city+widget.address.district+widget.address.detailedAddress,
                        style: TextStyle(fontSize: 16),),
                      ],
                    ),
                  ),
                ))
          ],
        ),),),
      bottomNavigationBar: BottomAppBar(
        child: Container(height: 80.0,
          child: RaisedButton(
            onPressed: publish,
            child: Text("保存",style: TextStyle(fontSize: 22),),
            color: Colors.lightBlue,),),
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();

    super.dispose();
  }
}
