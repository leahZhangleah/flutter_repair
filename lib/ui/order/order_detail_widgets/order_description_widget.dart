import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:repair_project/http/http_address_manager.dart';
import 'package:repair_project/ui/order/order_detail_bean/maintainer_description_list.dart';
import 'package:repair_project/ui/order/order_detail_bean/orders.dart';
import 'package:repair_project/ui/order/order_detail_bean/orders_description_list.dart';
import 'package:repair_project/ui/order/video_player_screen.dart';

class OrderDescriptionWidget extends StatelessWidget{
  Orders orders;

  OrderDescriptionWidget({this.orders});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      padding: EdgeInsets.all(8.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("创建时间：",style: TextStyle(color: Colors.grey)),
              Text(orders.createTime,style: TextStyle(color: Colors.grey),),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("订单编号：",style: TextStyle(color: Colors.grey)),
              Text(orders.orderNumber,style: TextStyle(color: Colors.grey),),

            ],
          ),
          buildDivider(),
          Container(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(orders.description,
                style: TextStyle(color: Colors.black)),
          ),
          Container(
            margin: EdgeInsets.only(top: 8.0),
              child: buildVideoView(context,orders)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("#" + orders.type, style: TextStyle(color: Colors.grey[400])),
              OutlineButton(
                borderSide: BorderSide(width: 1, color: Colors.lightBlue),
                child: Text("查看二维码",style: TextStyle(color: Colors.lightBlue),),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                onPressed: ()=>showQrCode(context,orders.qrcodeOrders),
              )
            ],
          ),

        ],
      ),
    );
  }

  buildDivider() => new Container(
    margin: EdgeInsets.only(top: 8.0),
    height: 2,
    color: Colors.grey[300],
  );

  void showQrCode(BuildContext context,String qrCode) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return QrImage(
            data: qrCode,
            size: 200,
          );
        }
    );
  }

  Widget buildVideoView(BuildContext context,Orders orders) {
    String repairVideoPath;
    String maintainVideoPath;
    if(orders.ordersDescriptionList.isNotEmpty){
      OrdersDescriptionList orderDescriptionList = orders.ordersDescriptionList[0];
      repairVideoPath = HttpAddressMananger().fileUploadServer + orderDescriptionList.url;
    }
    if(orders.maintainerDescriptionList.isNotEmpty){
      MaintainerDescriptionList maintainerDescriptionList = orders.maintainerDescriptionList[0];
      maintainVideoPath = HttpAddressMananger().fileUploadServer + maintainerDescriptionList.url;
    }
    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        repairVideoPath!=null?
        Column(
          children: <Widget>[
            Text("报修视频"),
            Container(
                margin: EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => Navigator.push(context,
                      new MaterialPageRoute(builder: (context) {
                        return new VideoPlayerScreen(url: repairVideoPath);
                      })),
                  child: Container(
                    width: 80.0,
                    height: 80.0,
                    child: Image.asset("assets/images/video_thumbnail.jpeg"),
                  ),
                )
            )
          ],
        ):Container(),
        maintainVideoPath!=null?
        Column(
          children: <Widget>[
            Text("维修视频"),
            Container(
                height: 80,
                margin: EdgeInsets.only(bottom: 5),
                child: GestureDetector(
                  onTap: () => Navigator.push(context,
                      new MaterialPageRoute(builder: (context) {
                        return new VideoPlayerScreen(url: maintainVideoPath);
                      })),
                  child: Image.asset("assets/images/video_thumbnail.jpeg"),
                ))
          ],
        ):Container()
      ],
    );
  }

}