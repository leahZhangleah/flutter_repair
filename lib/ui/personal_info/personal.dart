import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:repair_project/http/HttpUtils.dart';
import 'package:repair_project/http/api_request.dart';
import 'Name.dart';
import 'imagecut.dart';
import 'package:repair_project/ui/login/register.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'repairuser_db.dart';
import 'base_provider.dart';
import 'change_personal_info_bloc.dart';
import 'package:repair_project/http/http_address_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Personal extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PersonalState();
  }
}

class PersonalState extends State<Personal> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  num padingHorzation = 20.0;
  //String imageurl = "assets/images/person_placeholder.png";
  //var getInfo;
  bool isVideo = false;
  //Future<File> _imageFile;
  ChangePersonalInfoBloc personalInfoBloc;
  RepairUserDB currentRepairUserDB;

  void initState(){
    super.initState();
    //getInfo =  getPersonalInfo();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    personalInfoBloc = Provider.of<ChangePersonalInfoBloc>(context);
  }
  
  void _onImageButtonPressed(ImageSource source) async{
    setState(() {
      if (isVideo) {
        return;
      } else {
        ImagePicker.pickImage(source: source).then((file){
          if(file!=null){
            updatePersonHeading(file);
          }
        });
      }
    });
  }

  Future updatePersonHeading(File file) async{
    if(currentRepairUserDB!=null){
      Navigator.push<String>(
          context,new MaterialPageRoute(
          builder: (BuildContext context){
            return new Imagecut(imgFile:file,userId:currentRepairUserDB.userId,);//name: currentRepairUserDB.name,
          }));
    }else{
      Fluttertoast.showToast(msg: "id为空，无法更新头像");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("设置"),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=>Navigator.pop(context)),
      ),
      body: StreamBuilder(
          stream: personalInfoBloc.repairUserDB,
          builder: (context,AsyncSnapshot<RepairUserDB> snapshot){
            if(snapshot.hasData){
              currentRepairUserDB = snapshot.data;
              return _buildPersonalLine(snapshot);
            }else if(snapshot.hasError){
              return _buildErrorWidget(snapshot.error);
            }else{
              return _buildLoadingWidget();
            }
          }),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 80.0,
          child: RaisedButton(
            onPressed: (){
              showConfirmDialog();
            },
            child: Text(
              "退出登录",
              style: TextStyle(fontSize: 20),
            ),
            color: Colors.lightBlue,
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalLine(AsyncSnapshot<RepairUserDB> snapshot) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[300]),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "头像",
                    style: TextStyle(color: Colors.grey[350], fontSize: 18),
                  ),
                  RaisedButton(
                    shape: CircleBorder(),
                    onPressed: () => showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return new Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new ListTile(
                                  leading: new Icon(Icons.photo_camera),
                                  title: new Text("拍照"),
                                  onTap: ()=>_onImageButtonPressed(ImageSource.camera)
                              ),
                              new ListTile(
                                  leading: new Icon(Icons.photo_library),
                                  title: new Text("手机相册上传"),
                                  onTap: ()=>_onImageButtonPressed(ImageSource.gallery)
                              ),
                            ],
                          );
                        }),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      //Image.file(new File(snapshot.data.headimg),width: 75.0,height: 75.0,),
                      child:new Container(
                        width: 75.0,
                        height: 75.0,
                        child: buildImgWidget(snapshot.data.headimg),
                      )
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 5, 15, 10),
              child: Divider(
                height: 2,
                color: Colors.grey,
              ),
            ),
          ),
          Container(
              height: 70,
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 15, 20, 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "昵称",
                      style: TextStyle(color: Colors.grey[350], fontSize: 18),
                    ),
                    GestureDetector(
                        onTap: ()=>Navigator.push<String>(
                            context,new MaterialPageRoute(builder: (BuildContext context){
                          return new Name(name:snapshot.data.name,id:snapshot.data.id,userId: snapshot.data.userId,);
                        })
                        )
                        /*    .then((res){
                          _res=res;
                          name=_res;
                        })*/,
                        child: Text(snapshot.data.name, style: TextStyle(fontSize: 20),))
                  ],
                ),
              ))
        ],
      ),
    );
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
        placeholder: new CircularProgressIndicator(),
        errorWidget: new Icon(Icons.error),
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

  void showConfirmDialog() {
    showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title:
          CupertinoDialogAction(
            child: Text(
              "确认退出",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors
                      .redAccent),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () => ApiRequest().logout(context),
              child: Container(
                child: Text(
                  "确定",
                  style: TextStyle(
                      fontSize:
                      16,
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
                      fontSize:
                      14,
                      color: Colors
                          .black),
                ),
              ),
            ),
          ],
        );
      },
    );
  }


}
