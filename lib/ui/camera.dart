import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:repair_project/ui/publish_repair.dart';


class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  Camera({this.cameras});

  @override
  State<StatefulWidget> createState() {
    return CameraState();
  }
}

class CameraState extends State<Camera> with TickerProviderStateMixin {
  CameraController controller;
  AnimationController _controller;
  Animation<double> _animation;
  bool confirm = true;
  String videopath;
  @override
  void initState() {
    controller = CameraController(widget.cameras[0], ResolutionPreset.high);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });

    _controller =
    AnimationController(vsync: this, duration: Duration(seconds: 15))
      ..repeat();
    _animation = Tween(begin: 0.0, end: 15.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    )..addListener(() => setState(() => <String, void>{}));

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.stop();
        stopVideoRecording().then((_) {
          if (mounted) setState(() {});
        });
        setState(() {
          confirm = false;
        });
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.stop();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _controller.dispose();
    super.dispose();
  }

  void draw(TapDownDetails detail) {
    _controller.forward();
    startVideoRecording().then((String filePath) {
      if (mounted) setState(() {
        videopath=filePath;
      });
      if (filePath != null) print('Saving video to $filePath');
    });
    setState(() {
      confirm = true;
    });
  }

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      print('Error: select a camera first.');
    }
    String filePath = '${(await getExternalStorageDirectory()).path}/${timestamp()}.mp4';
    if (controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      print(e);
      return null;
    }
    return filePath;
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void stop(TapUpDetails detail) {
    _controller.stop();
    stopVideoRecording().then((_) {
      if (mounted) setState(() {});
    });
    setState(() {
      confirm = false;
    });
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }
    try {
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      print(e);
      return null;
    }
  }

  void cancel() {
    _controller.stop();
    stopVideoRecording().then((_) {
      if (mounted) setState(() {});
    });
    setState(() {
      confirm = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: AspectRatio(
            aspectRatio: MediaQuery.of(context).size.width/MediaQuery.of(context).size.height,
            child:
            Stack(alignment: FractionalOffset(0.5, 0.9), children: <Widget>[
              CameraPreview(controller),
              confirm
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Opacity(
                        opacity: 0.5,
                        child: Icon(
                          Icons.expand_more,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Opacity(
                      opacity: 0.5,
                      child: record(),
                    ),
                  )
                ],
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Opacity(
                    opacity: 0.5,
                    child: GestureDetector(
                      child: Icon(
                        Icons.close,
                        size: 80,
                        color: Colors.white,
                      ),
                      onTap: () {

                        setState(() {
                          _controller.reset();
                          _controller.stop();
                          confirm = true;
                        });
                      },
                    ),
                  ),
                  GestureDetector(
                    child: Icon(
                      Icons.done,
                      size: 80,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        new MaterialPageRoute(
                          builder: (c) {
                            return new PublishReapair(videopath:videopath);
                          },
                        ),
                      );
                      setState(() {
                        _controller.reset();
                        _controller.stop();
                        confirm = true;
                      });
                    },
                  )
                ],
              )
            ])));
  }

  Widget record() {
    return GestureDetector(
        onTapDown: draw,
        onTapUp: stop,
        onTapCancel: cancel,
        child: Stack(
          children: <Widget>[
            Container(
                height: 100,
                width: 100,
                child: CustomPaint(
                  painter: CircleProgressBarPainter(_animation.value),
                )),
            Container(
              height: 100,
              width: 100,
              decoration:
              BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            ),
          ],
        ));
  }
}

class CircleProgressBarPainter extends CustomPainter {
  final _animation;
  Paint _paintFore;
  var PI = 3.1415926;

  CircleProgressBarPainter(this._animation) {
    _paintFore = Paint()
      ..color = Colors.green
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2);
    canvas.drawArc(rect, -PI / 2, _animation * 2 * PI / 15, false, _paintFore);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}