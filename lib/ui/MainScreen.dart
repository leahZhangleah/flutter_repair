import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:repair_project/http/api_request.dart';
import 'package:repair_project/ui/camera.dart';
import 'package:repair_project/ui/cost_material/cost_material.dart';
import 'package:repair_project/ui/order/orderlist.dart';
import 'package:repair_project/ui/personal_info/base_provider.dart';
import 'package:repair_project/ui/personal_info/change_personal_info_bloc.dart';
import 'package:repair_project/ui/personal_info/personal_info_api.dart';
import 'package:repair_project/ui/publish_repair.dart';
import 'package:repair_project/ui/personal_info/mine_page.dart';
import 'package:repair_project/ui/repair_service/repairs_service_response.dart';
/**
 * 主界面
 */
class Main extends StatefulWidget {

  final int tabindex;
  Main({this.tabindex});

  @override
  MainScreenState createState() {
    return MainScreenState();
  }
}

class MainScreenState extends State<Main> with SingleTickerProviderStateMixin {
  TabController controller;
  var _pageList = [HomePage(), OrderList(), CostMaterial(), MinePage()];
  int _tabIndex = 0;


  void initState(){
    super.initState();
    ApiRequest().getRepairsServiceCharge(context);
    if(widget.tabindex!=null){
      _tabIndex = widget.tabindex;
    }return;
  }


  @override
  Widget build(BuildContext context) {

    return BlocProvider<ChangePersonalInfoBloc>(
      onDispose: (context,bloc)=>bloc.dispose(),
      builder: (context,bloc)=>bloc??ChangePersonalInfoBloc(PersonalInfoApi()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: _tabIndex == 0 ? HomePage() : _pageList[_tabIndex],
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    title: Text('首页'),
                    backgroundColor: Colors.red),
                BottomNavigationBarItem(
                    icon: Icon(Icons.assignment), title: Text('订单')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.memory), title: Text('耗材')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline), title: Text('我的')),
              ],
              type: BottomNavigationBarType.fixed,
              currentIndex: _tabIndex,
              iconSize: 24.0,
              onTap: (index) {
                setState(() {
                  _tabIndex = index;
                });
              },
            )),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.duration = const Duration(milliseconds: 20000)})
      : super(key: key);
  final Duration duration;

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomePage> with TickerProviderStateMixin {
  static const platform = const MethodChannel('annaru.flutter.io/repair');
  static const BasicMessageChannel channel =
      BasicMessageChannel<String>('com.mmd.flutterapp/plugin', StringCodec());

  @override
  bool get wantKeepAlive => true;

  AnimationController _rotateCtrl;
  Animation<double> _rotate;

  List<CameraDescription> cameras;

  Future<void> getCamera() async {
    cameras = await availableCameras();
  }

  @override
  void initState() {
    getCamera();
    _rotateCtrl = AnimationController(vsync: this, duration: widget.duration);
    _rotate = Tween(begin: 0.0, end: 360.0).animate(
      CurvedAnimation(parent: _rotateCtrl, curve: Curves.linear),
    )..addListener(() => setState(() => <String, void>{}));

    _rotateCtrl.repeat();

    channel.setMessageHandler((message) {
      Navigator.of(context).push(
        new MaterialPageRoute(
          builder: (c) {
            return new PublishReapair();
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _rotateCtrl.dispose();
    super.dispose();
  }

  /*
  * 打开相机
  * */
  openCamera() async {
    try {
      await platform.invokeMethod('present');
    } on PlatformException catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: null,
          body: new Center(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Stack(
                    children: <Widget>[
                      Transform.rotate(
                        angle: _rotate.value * 0.0174533,
                        child: new Container(
                          width: 535.0,
                          height: 330.0,
                          child: FlatButton(
                            onPressed: () {
                              if (Platform.isIOS) {
                                try {
                                  openCamera();
                                } on PlatformException catch (e) {}
                              } else {
                                Navigator.of(context).push(
                                  new MaterialPageRoute(
                                    builder: (c) {
                                      return new Camera(cameras: cameras);
                                    },
                                  ),
                                );
                              }
                            },
                            color: const Color(0xffffffff),
                            child: Image.asset("images/homepagebtn.png",
                                fit: BoxFit.fill),
                            shape: new CircleBorder(
                              side: new BorderSide(
                                color: const Color(0xffffffff),
                                width: 1.0,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}