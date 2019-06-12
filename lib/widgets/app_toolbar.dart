import 'package:flutter/material.dart';
import 'package:repair_project/ui/_index.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_project/constant/constant.dart';
class Toolbar extends StatelessWidget {

  Widget title;
  BuildContext _context;

  Toolbar(this._context,this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: Colors.blue[400]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('闵行区', style: TextStyle(color: Colors.white)),
          IconButton(
            icon: Icon(Icons.arrow_drop_down),
            tooltip: "上海闵行",
            onPressed: null,
          ),
          Expanded(
            child: Center(child: title),
          ),
          IconButton(
            icon: Icon(Icons.contacts, color: Colors.white, size: 24),
            tooltip: '聊天',
            onPressed: (){
              Fluttertoast.showToast(
                  msg: "This is Center Short Toast",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white
              );

              Navigator.of(_context).pushNamed(CHAT);
            },
          ),
          IconButton(
            icon: Icon(Icons.more_horiz, color: Colors.white, size: 24),
            tooltip: '更多',
            onPressed: null,
          )
        ],
      ),
    );
  }
}
