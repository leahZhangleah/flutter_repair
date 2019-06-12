import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:repair_project/http/http_address_manager.dart';

class FeedBack extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new FeedBackState();
  }
}

class FeedBackState extends State<FeedBack> {

  void initState(){
    super.initState();
  }

  Future updatePersonalInfo() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    Options options = new Options();
    options.headers = {"token": token};
    try {
      Response response = await Dio().post(
          HttpAddressMananger().getFeedbackUrl(),
          options: options,
          data: {
            'opinion':_controller.text
          });
      print(response);
    } catch (e) {
      print(e);
    }
  }

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("意见反馈"),
          leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: ()=>Navigator.pop(context)),
          centerTitle: true,
          actions: <Widget>[
            GestureDetector(
                onTap: (){
                  if (_controller.text == null) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => new AlertDialog(title: new Text("请填写反馈信息") ));
                    return;
                  }
                  updatePersonalInfo();
                  Navigator.pop(context,_controller.text);
                },
                child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        '发布',
                      ),
                    )))
          ],
        ),
        body: Container(
            decoration: BoxDecoration(color: Colors.grey[200]),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Padding(padding: EdgeInsets.only(left: 10),
                      child:TextField(
                        maxLines: 10,
                          controller: _controller,
                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.only(top: 15),
                              border: InputBorder.none,
                              hintText: "快来写下您对本公司的意见建议",
                              hintStyle: TextStyle(color:Colors.grey[300],fontSize: 20)
                          )
                      )
                  ),
                )
              ],
            ))
    );
  }
}
