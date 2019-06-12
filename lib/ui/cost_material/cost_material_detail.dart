import 'package:flutter/material.dart';
import 'package:repair_project/http/HttpUtils.dart';
import 'package:repair_project/widgets/titlebar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CostMaterialDetails extends StatelessWidget{
  final String id,picture,description,name;
  CostMaterialDetails({this.id,this.description,this.picture,this.name});


  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("耗材详情"),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=>Navigator.pop(context)),
      ),
      body:SingleChildScrollView(child:Container(
        decoration: BoxDecoration(color: Colors.grey[300]),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Image.network(picture,fit: BoxFit.fitWidth),
          Column(crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child:Padding(
                  padding:EdgeInsets.all(10),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text("材料名称",style: TextStyle(color: Colors.grey),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text(name,style: textTheme.headline,),
                      ),
                    ],
                  ),
                ),),
                Container(
                 decoration: BoxDecoration(color: Colors.grey[300]),
                 child: SizedBox(
                   height: 20,
                 ),
               ),
                Container(
                  decoration: BoxDecoration(color: Colors.white),
                child:Padding(
                  padding:EdgeInsets.all(10),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text("材料特点",style: TextStyle(color: Colors.grey),),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 6),
                        child:Text(description,
                          style: textTheme.headline.copyWith(fontSize: 16),)),
                    ],
                  ),
                ),),
              ],),
        ],
      ),
      )),
      bottomNavigationBar: BottomAppBar(
        child: Container(height: 50.0,
        child: RaisedButton(
          onPressed: () async{
            const url = "https://baike.baidu.com/item/%E9%95%80%E9%94%8C%E9%92%A2%E7%AE%A1/10566851?fr=aladdin";
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
          child: Text("点击了解更多"),
          color: Colors.lightBlue,),),
      ),

    );
  }

}