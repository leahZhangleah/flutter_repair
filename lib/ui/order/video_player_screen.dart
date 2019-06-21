import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:io';
class VideoPlayerScreen extends StatefulWidget {
  String url;
  VideoPlayerScreen({this.url});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  bool _initialised=false;

  @override
  void initState() {


    // Initialize the controller and store the Future for later use
   /* _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video
    _controller.setLooping(true);*/
    super.initState();
    initVideoPlayer();
  }

  void initVideoPlayer(){
    _getLocalFileUrl(widget.url).then((filePath){
      _controller = VideoPlayerController.file(
        new File(filePath),
      );
      _controller.initialize().then((value){
        setState(() {
          _initialised=true;
        });
      });
    });
  }

  Future<String> _getLocalFileUrl(String url) async{
    var file = await DefaultCacheManager().getSingleFile(url);
    print(file.path);
    return file.path;
  }

  @override
  void dispose() {
    // Ensure you dispose the VideoPlayerController to free up resources
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //var orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: Text("播放视频"),
        centerTitle: true,
      ),
      // Use a FutureBuilder to display a loading spinner while you wait for the
      // VideoPlayerController to finish initializing.
      body: OrientationBuilder(
        builder:(context,orientation){
          return RotatedBox(
            quarterTurns: orientation==Orientation.landscape?1:0,
            //width: MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.height,
            child: Center(
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                      _controller.setLooping(true);
                    });
                  },
                  child: Center(
                    child: Container(
                        margin: EdgeInsets.only(left: 8.0,right: 8.0),
                        child: Stack(
                          alignment: FractionalOffset(0.5, 0.5),
                          children: <Widget>[
                            _initialised?
                            AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              // Use the VideoPlayer widget to display the video
                              child: VideoPlayer(_controller),
                            ):Center(child: CircularProgressIndicator()),
                            _initialised?
                            Center(
                              child: _controller.value.isPlaying
                                  ? Icon(
                                Icons.pause_circle_outline,
                                size: 60,
                                color: Colors.grey,
                              )
                                  : Icon(
                                Icons.play_circle_outline,
                                size: 60,
                                color: Colors.grey,
                              ),
                            ):Container()
                          ],
                        )),
                  )),
            ),
          );
        },
      )
    );
  }
}