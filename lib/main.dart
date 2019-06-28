import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:repair_project/ui/address/choose_address.dart';
import 'package:repair_project/ui/_index.dart';
import 'package:repair_project/constant/constant.dart';
import 'package:repair_project/ui/classify.dart';
import 'package:repair_project/ui/publish_repair.dart';
import 'package:repair_project/ui/repair_classify.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum Actions{Increase}

Future<void> main() async {//入口
  Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage,PermissionGroup.camera,PermissionGroup.speech]);
  //入口
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(new Rooter());
}


class Rooter extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<Rooter> with SingleTickerProviderStateMixin {

  final routes = <String, WidgetBuilder>{
    HOME: (context) => Main(), //主页//欢迎
    REGISTER: (context) => RegisterScreen(null), //注册
    REPAIR_CLASSIFY: (context) => Classify(), //
    REPAIR_PUBLISH: (context) => PublishReapair(), // 维修分类
    CHOOSE_ADDRESS: (context) => ChooseAddress(), //选择地址
  };

  String key = "";
  String account = "";

  @override
  void initState() {
    super.initState();
//    fluwx.register(appId: "wxd930ea5d5a258f4f", doOnAndroid: true, doOnIOS: true, enableMTA: false);
  }

   Future<String> getToken() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    String phoneNo = sp.getString("account");
    setState(() {
      key=token;
      account = phoneNo;
    });
    return token;
  }

  @override
  Widget build(BuildContext context) {
    getToken();
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '',
        routes: routes,
        home: key==null?RegisterScreen(account):Main(),
        );
  }
}
