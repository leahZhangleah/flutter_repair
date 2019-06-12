import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_project/entity/description.dart';
import 'package:repair_project/logic/bloc/menu_bloc.dart';
import 'package:repair_project/model/menu.dart';
import 'package:repair_project/ui/address/choose_address.dart';
import 'package:repair_project/widgets/bottom_button.dart';

class Classify extends StatefulWidget {
  final String detail, url;
  final Description description;

  Classify({this.detail, this.url, this.description});

  _ClassifyState createState() => _ClassifyState();
}

class _ClassifyState extends State<Classify> {
  final _scaffoldState = GlobalKey<ScaffoldState>();
  Size deviceSize;
  BuildContext _context;
  num padingHorzation = 60;
  var _choosed = [false, false, false, false];
  num classify;

  @override
  Widget build(BuildContext context) {
    _context = context;
    deviceSize = MediaQuery.of(_context).size;
    padingHorzation = deviceSize.width / 4;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: AppBar(
                backgroundColor: Colors.blue,
                centerTitle: true,
                title: Text("维修分类"),
                leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context)))),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Expanded(
              flex: 1,
              child: homeScaffold(_context),
            ),
            NextButton(
              padingHorzation: padingHorzation,
              text: "下一步",
              onNext: () {
                if(classify==null){
                  Fluttertoast.showToast(msg: "请选择维修类型");
                  return;
                }
                Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (c) {
                      return new ChooseAddress(
                          detail: widget.detail,
                          url: widget.url,
                          classify: classify,
                          description: widget.description,
                          inPublish: true,);
                    },
                  ),
                );
              },
            )
          ],
        ));
  }

  homeScaffold(BuildContext context) => new Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: Scaffold(key: _scaffoldState, body: homeBodyAndroid()),
      );

  void _handleTapDown(index) {
    setState(() {
      for (int i = 0; i < 4; i++) {
        _choosed[i] = false;
      }
      _choosed[index] = true;
      classify = index;
    });
  }

  Widget homeBodyAndroid() {
    MenuBloc menuBloc = MenuBloc();
    return StreamBuilder<List<Menu>>(
      stream: menuBloc.menuItems,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? CustomScrollView(
                slivers: <Widget>[bodyGrid(snapshot.data)],
              )
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget bodyGrid(List<Menu> menus) => SliverGrid(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        ),
        delegate: new SliverChildBuilderDelegate(
          (context, index) {
            return buildCardItem(context, menus[index], index);
          },
          childCount: menus.length,
        ),
      );

  Widget buildCardItem(BuildContext context, Menu menu, int index) {
    return GestureDetector(
      onTap: () {
        _handleTapDown(index);
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2.0,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            menuColor(menu, index),
            menuData(menu),
          ],
        ),
      ),
    );
  }

  Widget menuColor(Menu menu, index) => Container(
        decoration: BoxDecoration(
          border: _choosed[index]
              ? Border.all(
                  color: Colors.lightBlue,
                  width: 4.0,
                )
              : null,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
            ),
          ],
        ),
      );

  Widget menuData(Menu menu) => new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Icon(Icons.code),
          Text(
            menu.title,
            style: TextStyle(color: Colors.black, fontSize: 22),
          )
        ],
      );
}
