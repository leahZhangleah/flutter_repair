
import 'dart:async';
import 'repairuser_db.dart';
import 'personal_info_api.dart';
import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:repair_project/http/HttpUtils.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ChangePersonalInfoBloc{
  final PersonalInfoApi personalInfoApi;
  //String userName;
  BehaviorSubject<RepairUserDB> _repairsUserController;
  ValueObservable<RepairUserDB> get repairUserDB => _repairsUserController.stream;
  //Stream<String> get image => _imageController.stream;

  ChangePersonalInfoBloc(this.personalInfoApi){
    _repairsUserController = BehaviorSubject<RepairUserDB>();
    
  }


  Future<void> getPersonalInfo() async {
    bool internet = await RequestManager.hasInternet();
    if(internet){
      RepairUserDB repairUserDB = await personalInfoApi.getPersonalInfo();
      _repairsUserController.add(repairUserDB);
    }else{
      _repairsUserController.add(null);
    }

  }

  Future<void> updateImage(File file,String userId)async{
    bool result = await personalInfoApi.updateImage(file, userId);
    if(result){
      await getPersonalInfo();
    }
    /*if(repairUserDb!=null){
      _repairsUserController.add(repairUserDb);
    }else{

    }*/
  }

  Future<void> updateName(String id,String userId,String newName) async{
    await personalInfoApi.updateName(id,userId, newName);
    await getPersonalInfo();
    //todo
  }

  /*
  Future<void> insertPersonalInfoInDB(String id,String name, String headimg)async{
    var result = await personalInfoApi.insertNewPersonalInfoIntoDB(id, name,headimg);
    print("the returned updated id is: "+String.fromCharCode(result));
    if(result >=0){
      await getPersonalInfo();
    }

  }*/

  void dispose(){
    _repairsUserController.close();
    //_imageController.close();
  }



    /*String image = json
        .decode(response.data.toString())
        .cast<String, dynamic>()['repairsUser']['headimg'];
    if(image==null){
      image = "assets/images/person_placeholder.png";
    }
    _imageController.sink.add(image);*/
}