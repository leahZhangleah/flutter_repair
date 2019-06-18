import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'base_provider.dart';
import 'change_personal_info_bloc.dart';

class Imagecut extends StatefulWidget {
  final File imgFile;
  final String userId;
  //final String name;
  Imagecut({this.imgFile,this.userId});
  
  @override
  ImagecutState createState() => ImagecutState();
}

class ImagecutState extends State<Imagecut> {
  ChangePersonalInfoBloc personalInfoBloc;
  File imageFile;
  //String imageurl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    personalInfoBloc = Provider.of<ChangePersonalInfoBloc>(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageFile = widget.imgFile;
  }

  @override
  Widget build(BuildContext context) {
   //imageFile==null?imageurl=widget.imgurl:imageurl=imageFile.path;
   return Scaffold(
      appBar: AppBar(
        title: Text("裁剪头像"),
        centerTitle: true,
        actions: <Widget>[
          GestureDetector(
              onTap: (){
                personalInfoBloc.updateImage(context,imageFile, widget.userId);
                Navigator.pop(context);
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
      body: Center(
        child: Image.file(imageFile),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            _cropImage();
        },
        child: _buildButtonIcon(),
      ),
    );
  }

  Widget _buildButtonIcon() {
      return Icon(Icons.crop);
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      toolbarTitle: 'Cropper',
      toolbarColor: Colors.blue,
      circleShape: true,
      toolbarWidgetColor: Colors.white,
    );
    if (croppedFile != null) {
      setState(() {
        imageFile = croppedFile;
      });
      print("经过裁剪后的图片路径为："+imageFile.path);
    }
  }

}
