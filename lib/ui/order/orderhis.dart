import 'package:flutter/material.dart';
import 'package:repair_project/entity/tabtitle.dart';
import 'package:repair_project/ui/order/missedorder.dart';
import 'package:repair_project/ui/order/orderfinish.dart';
import 'package:repair_project/ui/order/quotedorder.dart';
import 'package:repair_project/ui/order/rfqorder.dart';
import 'package:repair_project/widgets/behavior.dart';

class OrderHistory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OrderHistoryState();
  }
}

class OrderHistoryState extends State<OrderHistory>
    with SingleTickerProviderStateMixin {
  TabController mController;
  List<TabTitle> tabList;
  int currentPage;

  @override
  void initState() {
    super.initState();
    initTabData();
    mController =
        TabController(length: tabList.length, vsync: this, initialIndex: 0);
  }

  initTabData() {
    tabList = [
      new TabTitle('未接单', 0),
      new TabTitle('待报价', 1),
      new TabTitle('已报价', 2),
      new TabTitle('已完成', 3)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context)),
          title: Text(
            "订单列表",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          bottom: TabBar(
            unselectedLabelColor: Colors.white24,
            indicatorColor: Colors.white,
            controller: mController,
            isScrollable: true,
            labelColor: Colors.white,
            tabs: tabList.map((item) {
              return Tab(
                  child: Text(item.title,
                      style: TextStyle(fontSize: 18, wordSpacing: 2)));
            }).toList(),
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
        body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: TabBarView(
            controller: mController,
            children: tabList.map((item) {
              return Stack(
                children: <Widget>[
                  Center(
                      child: item.index == 0
                          ? OrderMissed()
                          : item.index == 1
                              ? OrderRFQ()
                              : item.index == 2 ? OrderQuote() : OrderFinish())
                ],
              );
            }).toList(),
          ),
        ));
  }
}
