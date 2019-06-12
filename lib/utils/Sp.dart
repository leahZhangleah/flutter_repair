import 'package:shared_preferences/shared_preferences.dart';

class Sp{
  
  static put(String key ,value) async{
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(key,value);
  }
  
  static getS(String key, Function callback){
    SharedPreferences.getInstance().then((prefs){
      callback(prefs.getString(key));
    });
  }

  static putUserName(String value){
    put("username",value);
  }

}