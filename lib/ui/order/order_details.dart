import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repair_project/http/HttpUtils.dart';
import 'package:repair_project/ui/pay/pay_ servicefee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:repair_project/http/http_address_manager.dart';
import 'package:repair_project/http/api_request.dart';

class OrderDetiails extends StatefulWidget {
  final String ordertype,
      description,
      name,
      phone,
      address,
      ordernumber,
      createTime,
      type,
      videopath,
      id;

  final int state;

  OrderDetiails(
      {this.ordertype,
      this.description,
      this.name,
      this.phone,
      this.address,
      this.ordernumber,
      this.createTime,
      this.type,
      this.state,
      this.videopath,
      this.id});

  @override
  State<StatefulWidget> createState() {
    return OrderDetiailsState();
  }
}

class OrderDetiailsState extends State<OrderDetiails> {
  VideoPlayerController _videoPlayerController;
  bool initialized = false;

  void initState() {
    _videoPlayerController = VideoPlayerController.network(widget.videopath);
    _videoPlayerController.initialize().then((value) {
      initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("订单详情"),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)),
      ),
      body: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                buildOrderState(), //80
                buildOrderDestription(), //120
                buildDivider(), //15
                buildOrderInfo(), //75
                buildDivider(), //15
                buildOther(), //86
                buildDivider(), //15
              ],
            );
          }),
      bottomNavigationBar: BottomAppBar(
        child: Container(
            margin: EdgeInsets.only(right: 20),
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                widget.state==0?
                OutlineButton(
                    borderSide: BorderSide(
                        width: 1,
                        color: Colors.lightBlue),
                    color: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(
                            Radius.circular(5))),
                    child: Text("确认发布",
                        style: new TextStyle(
                            color: Colors.lightBlue)),
                    onPressed: () {
                      showDialog<bool>(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title:
                            CupertinoDialogAction(
                              child: Text(
                                "订单发布",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors
                                        .redAccent),
                              ),
                            ),
                            content:
                            CupertinoDialogAction(
                              child: Text(
                                "发布订单需要支付￥20元的服务费",
                                style: TextStyle(
                                    fontSize: 16,
                                    color:
                                    Colors.black),
                              ),
                            ),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                onPressed: () =>
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (
                                                BuildContext context) {
                                              return new Payfee(id:widget.id,des:widget.description);
                                            })),
                                child: Container(
                                  child: Text(
                                    "确定",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors
                                            .black),
                                  ),
                                ),
                              ),
                              CupertinoDialogAction(
                                onPressed: () {
                                  Navigator.pop(
                                      context);
                                },
                                child: Container(
                                  child: Text(
                                    "取消",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors
                                            .black),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }):OutlineButton(
                  borderSide: BorderSide(
                      width: 1, color: Colors.lightBlue),
                  disabledBorderColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(
                          Radius.circular(5))),
                  child: Text("已确认",
                      style: new TextStyle(
                          color: Colors.black)),
                ),
                Padding(padding: EdgeInsets.only(
                    right: 5),),
                OutlineButton(
                    borderSide: BorderSide(
                        width: 1, color: Colors.grey),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(
                            Radius.circular(5))),
                    child: Text("取消订单",
                        style: new TextStyle(
                            color: Colors.black)),
                    onPressed: () {
                      showDialog<bool>(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title:
                            CupertinoDialogAction(
                              child: Text(
                                "确认取消",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors
                                        .redAccent),
                              ),
                            ),
                            content:
                            CupertinoDialogAction(
                              child: Text(
                                "订单取消后不可恢复",
                                style: TextStyle(
                                    fontSize: 16,
                                    color:
                                    Colors.black),
                              ),
                            ),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                onPressed: () =>
                                   ApiRequest().cancelOrder(
                                        widget
                                            .id),
                                child: Container(
                                  child: Text(
                                    "确定",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors
                                            .black),
                                  ),
                                ),
                              ),
                              CupertinoDialogAction(
                                onPressed: () {
                                  Navigator.pop(
                                      context);
                                },
                                child: Container(
                                  child: Text(
                                    "取消",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors
                                            .black),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    })
              ],
            )),
      ),
    );
  }

  //公用行
  buildOrderInfo() {
    return Container(
      height: 75,
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(widget.name),
              SizedBox(width: 20),
              Text(widget.phone),
            ],
          ),
          SizedBox(height: 10),
          Text(widget.address)
        ],
      ),
    );
  }

  //公用行
  buildOther() => new Container(
        margin: EdgeInsets.only(left: 10),
//    child: Text("等待报价",style: TextStyle(color: Colors.black)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Text("订单编号: " + widget.ordernumber)),
            Container(
              margin: EdgeInsets.only(left: 0, right: 15),
              child: Divider(height: 1, color: Colors.grey),
            ),
            Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Text("下单时间: " + widget.createTime)),
          ],
        ),
      );

  buildDivider() => new Container(
        height: 15,
        color: Colors.grey[300],
      );

  //抬头（未接单，待报价，已报价，已完成）
  buildOrderState() => new Container(
      decoration: BoxDecoration(color: Colors.blue),
      padding: EdgeInsets.only(top: 15, bottom: 15, left: 15),
      child: Text(
        widget.ordertype,
        style: TextStyle(fontSize: 36, fontWeight: FontWeight.w100),
      ));

  //第二块
  buildOrderDestription() => new Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: Text(widget.description,
                  style: TextStyle(color: Colors.black)),
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
                child: Container(
                    margin: EdgeInsets.all(20),
                    child: Stack(
                      alignment: FractionalOffset(0.5, 0.5),
                      children: <Widget>[
                        initialized
                            ? AspectRatio(
                                aspectRatio: 3 / 4,
                                child: VideoPlayer(_videoPlayerController),
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
                    ))),
            Text("#" + widget.type, style: TextStyle(color: Colors.grey[400])),
          ],
        ),
      );

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

}
