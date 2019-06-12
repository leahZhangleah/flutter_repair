import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_project/ui/login/take_photo.dart';
import 'package:repair_project/utils/routebuilder.dart';
import 'package:repair_project/widgets/titlebar.dart';

class IdCardUpload extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return IdCardUploadState();
  }
}

class IdCardUploadState extends State<IdCardUpload> {
  List<String> imgPaths;
  num deviceWidth;
  num deviceHeight;

  @override
  void initState() {
    super.initState();
    imgPaths = new List(2);
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    deviceWidth = deviceSize.width;
    deviceHeight = deviceSize.height;

    return Material(
        child: Scaffold(
      appBar: PreferredSize(
          child: Titlebar1(
              titleValue: "修一修",
              actionValue: "...",
              leadingCallback: null,
              actionCallback: null),
          preferredSize: Size.fromHeight(50)),
      body: Container(
          color: Colors.grey[300],
          width: deviceWidth,
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              buildItemCard(0),
              SizedBox(height: 15),
              buildItemCard(1),
            ],
          )),
    ));
  }

  Widget buildItemCard(int index) {
    return GestureDetector(
        onTap: () async {
          if (index == 0) {
            Fluttertoast.showToast(msg: "0");
            String resImagPath = await Navigator.of(context).push(MyRouteBuilder.getInstance(TakePhoto()));
            setState(() {
              imgPaths[0] = resImagPath;
            });
          } else {
            Fluttertoast.showToast(msg: "1");
            setState(() {
              imgPaths[1] = "abc";
            });
          }
        },
        child: imgPaths[index] == null
            ? Container(
                width: deviceWidth,
                color: Colors.white,
                height: deviceHeight / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Icon(Icons.camera_alt, size: 50),
                    Text(index == 0 ? "拍摄身份证正面" : "拍摄身份证背面"),
                  ],
                ),
              )
            : Image.asset(
                "images/cat.jpg",
                fit: BoxFit.fitWidth,
              ));
  }
}
