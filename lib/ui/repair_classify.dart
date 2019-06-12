import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:repair_project/logic/bloc/menu_bloc.dart';
import 'package:repair_project/model/menu.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_project/ui/address/choose_address.dart';
import 'package:repair_project/widgets/bottom_button.dart';

class RepairClassify extends StatelessWidget {
  final _scaffoldState = GlobalKey<ScaffoldState>();
  Size deviceSize;
  BuildContext _context;
  num padingHorzation = 60;
  bool _choosed = false;
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
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context)))),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            defaultTargetPlatform == TargetPlatform.iOS
                ? Expanded(
                    flex: 1,
                    child: homeIOS(_context),
                  )
                : Expanded(
                    flex: 1,
                    child: homeScaffold(_context),
                  ),
            NextButton(
              padingHorzation: padingHorzation,
              text: "下一步",
              onNext: (){
                Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (c) {
                      return new ChooseAddress();
                    },
                  ),
                );

              },
            )
          ],
        ));
  }

  homeIOS(BuildContext context) => new Theme(
        data: ThemeData(
          fontFamily: '.SF Pro Text',
        ).copyWith(canvasColor: Colors.transparent),
        child: CupertinoPageScaffold(
          child: CustomScrollView(
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                border: Border(bottom: BorderSide.none),
                backgroundColor: CupertinoColors.white,
                largeTitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("修一修"),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: CircleAvatar(
                        radius: 15.0,
                        backgroundColor: CupertinoColors.black,
                        child: FlutterLogo(
                          size: 15.0,
                          colors: Colors.yellow,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              homeBodyIOS(context)
            ],
          ),
        ),
      );

  homeScaffold(BuildContext context) => new Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: Scaffold(key: _scaffoldState, body: homeBodyAndroid()),
      );

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

  void _handleTapDown(){
    _choosed = true;
}

  Widget buildCardItem(BuildContext context, Menu menu) {
    return GestureDetector(
      onTap: _handleTapDown, // 分析 1
//      onTap: () => _openDetailPage(context, menu),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2.0,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            menuColor(),
            menuData(menu),
          ],
        ),
      ),
    );
  }

  Widget bodyGrid(List<Menu> menus) => new SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 0.0,
        childAspectRatio: 1.0,
      ),
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return buildCardItem(context, menus[index]);
      }, childCount: menus.length));

  _openDetailPage(context, menu) {
  }

  Widget menuImage(Menu menu) => new Image.asset(
        menu.image,
        fit: BoxFit.cover,
      );

  Widget menuColor() => new Container(
        decoration: BoxDecoration(
          border: _choosed?Border.all(
            color: Colors.lightBlue,
            width: 4.0,
          ):null,
          boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
          ),
        ],),
      );

  Widget menuData(Menu menu) => new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Text(
            menu.title,
            style: TextStyle(color: Colors.black,fontSize: 22),
          )
        ],
      );

  homeBodyIOS(BuildContext context) {
    MenuBloc menuBloc = MenuBloc();
    return StreamBuilder<List<Menu>>(
      stream: menuBloc.menuItems,
      initialData: List(),
      builder: (context, snapshot) {
        snapshot.hasData
            ? bodyDatIOS(snapshot.data, context)
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  bodyDatIOS(List<Menu> data, BuildContext context) => new SliverList(
        delegate: SliverChildListDelegate(
            data.map((menu) => menuIOS(menu, context)).toList()),
      );

  Widget menuIOS(Menu menu, BuildContext context) {
    return Container(
      height: deviceSize.height / 2,
      decoration: ShapeDecoration(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 3.0,
        margin: EdgeInsets.all(16.0),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                menu.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              height: 60.0,
              child: Container(
                width: double.infinity,
                color: menu.menuColor,
                child: iosCardBottom(menu, context),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget iosCardBottom(Menu menu, BuildContext context) => new Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: 40.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(width: 3.0, color: Colors.white),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        menu.image,
                      ))),
            ),
            SizedBox(
              width: 20.0,
            ),
            Text(
              menu.title,
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 20.0,
            ),
            FittedBox(
              child: CupertinoButton(
                onPressed: () => _openDetailPage(_context, menu),
                borderRadius: BorderRadius.circular(50.0),
                child: Text(
                  "Go",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: CupertinoColors.activeBlue),
                ),
                color: Colors.white,
              ),
            )
          ],
        ),
      );

}
