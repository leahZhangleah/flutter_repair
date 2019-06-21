import 'package:flutter/material.dart';
import 'package:repair_project/entity/tabtitle.dart';
import 'package:repair_project/ui/order/missedorder.dart';
import 'package:repair_project/ui/order/quotedorder.dart';
import 'package:repair_project/ui/order/rfqorder.dart';
import 'package:repair_project/widgets/behavior.dart';

class OrderList extends StatefulWidget {

  final int sindex;
  OrderList({this.sindex});

  @override
  State<StatefulWidget> createState() {
    return OrderListState();
  }
}

class OrderListState extends State<OrderList> with SingleTickerProviderStateMixin {
  TabController mController;
  List<TabTitle> tabList;
  int currentPage;

  @override
  void initState() {
    super.initState();
    initTabData();
    mController = TabController(
      length: tabList.length,
      vsync: this,
      initialIndex: widget.sindex==null?0:widget.sindex
    );
  }

  initTabData() {
    tabList = [
      new TabTitle('未接单', 0),
      new TabTitle('待报价', 1),
      new TabTitle('已报价', 2)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "订单列表",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
                  unselectedLabelColor: Colors.white24,
                  indicatorColor: Colors.white,
                  controller: mController,
                  isScrollable: true,
                  labelColor: Colors.white,
                  tabs: tabList.map((item) {
                    return Tab(
                        child:
                            Text(item.title,style: TextStyle(fontSize: 18,wordSpacing: 2)));
                  }).toList(),
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
              ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: TabBarView(
        controller: mController,
        children: tabList.map((item) {
          return  Stack(
            children: <Widget>[
              Center(
                  child: item.index == 0 ? OrderMissed():
                  item.index == 1?OrderRFQ():
                  OrderQuote()
              )
            ],
          );
        }).toList(),
      ),)
    );
  }

}
