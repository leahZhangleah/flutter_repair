import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_project/entity/description.dart';
import 'package:repair_project/ui/classify.dart';
import 'package:repair_project/widgets/bottom_button.dart';
import 'package:video_player/video_player.dart';
import 'package:connectivity/connectivity.dart';
import 'package:repair_project/http/http_address_manager.dart';

class PublishReapair extends StatefulWidget {
  final String videopath;

  PublishReapair({this.videopath});

  @override
  State<StatefulWidget> createState() {
    return PublishState();
  }
}

class PublishState extends State<PublishReapair> {
  static const platform = const MethodChannel('annaru.flutter.io/repair');
  String _url = "";
  Size deviceSize;
  BuildContext _context;
  num padingHorzation = 60;
  num itemHeight = 80;
  double _percent, _value;
  String __value = "";
  Description description;
  bool connection;
  final TextEditingController _textcontroller = new TextEditingController();

  VideoPlayerController _videoPlayerController;
  bool initialized = false;

  Future geturl() async {
    var filename = await platform.invokeMethod('getUrl');
    print(filename);
    return filename;
  }

  Future<void> _uploadVideo(String _url) async {
    Dio dio = new Dio();
    FormData formData = new FormData.from({
      "file": new UploadFileInfo(new File(_url), _url),
    });

    Response response = await dio.post(
      HttpAddressMananger().getUploadVideoAddress(),//"http://115.159.93.175:80/upload/uploadVideo"
      data: formData,
      onUploadProgress: (int sent, int total) {
        setState(() {
          _percent = sent / total;
          _value = _percent * 100;
          __value = _value.toStringAsFixed(0);
        });
      },
    );
    description = Description.allFromResponse(response.toString());
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      connection = true;
    } else {
      connection = false;
    }
    return connection;
  }

  void initVideoPlayer(String url) {
    _url = url.toString();
    _videoPlayerController = VideoPlayerController.file(new File("$_url"));
    _videoPlayerController.initialize().then((value) {
      initialized = true;
      _uploadVideo(_url);
      setState(() {});
    });
  }

  @override
  void initState() {
    if (widget.videopath == null) {
      geturl().then((_) => initVideoPlayer(_.toString()));
    } else {
      initVideoPlayer(widget.videopath);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    deviceSize = MediaQuery.of(_context).size;
    padingHorzation = deviceSize.width / 4;
    itemHeight = deviceSize.height / 5;
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context)),
            title: Text(
              "发布维修",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
          preferredSize: Size.fromHeight(50)),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Platform.isIOS
                ? FutureBuilder(
                    builder: _buildFuture,
                    future:
                        geturl(), // 用户定义的需要异步执行的代码，类型为Future<String>或者null的变量或函数
                  )
                : GestureDetector(
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
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(20),
              child: TextField(
                autocorrect: true,
                style: TextStyle(fontSize: 16, color: Colors.black),
                maxLines: 10,
                textAlign: TextAlign.left,
                scrollPadding: EdgeInsets.all(0),
                autofocus: false,
                controller: _textcontroller,
                decoration: InputDecoration.collapsed(
                  hintText: "请在此简要描述损坏情况",
                  fillColor: Colors.orange,
                  filled: false,
                  hasFloatingPlaceholder: true,
                ),
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(bottom: 10),
              child: __value == "100"
                  ? buildNextButton(context)
                  : progress(context)),
        ],
      ),
    );
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
        return GestureDetector(
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
                )));
      default:
        return null;
    }
  }

  Widget buildNextButton(BuildContext context) => NextButton(
        padingHorzation: padingHorzation,
        text: "下一步",
        onNext: () {
          if (_textcontroller.text == '') {
            Fluttertoast.showToast(msg: "请填写损坏情况");
            return;
          }
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (c) {
                return new Classify(
                    detail: _textcontroller.text,
                    url: _url,
                    description: description);
              },
            ),
          );
        },
      );

  Widget progress(BuildContext context) {
    return FutureBuilder(
        future: checkInternetConnection(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data) {
              return Column(
                children: <Widget>[
//        CircularProgressIndicator(),
                  SizedBox(
                      child: LinearProgressIndicator(
                    value: _percent,
                    valueColor: AlwaysStoppedAnimation(
                        _percent == null ? Colors.transparent : Colors.black),
                  )),
                  Offstage(
                      offstage: __value.length == 0 ? true : false,
                      child: Text("$__value%"))
                ],
              );
            } else {
              Fluttertoast.showToast(msg: "请检查网络");
              return Container();
            }
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }
}
