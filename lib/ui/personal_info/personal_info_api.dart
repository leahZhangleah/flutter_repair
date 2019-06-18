import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:repair_project/http/HttpUtils.dart';
import 'dart:convert';
import 'repair_user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'repairuser_db.dart';
import 'personal_info_response.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:repair_project/http/http_address_manager.dart';
import 'package:repair_project/http/api_request.dart';
class PersonalInfoApi {

  int _oneDayMilliSeconds = 86400;
  Future<RepairUserDB> getPersonalInfo(BuildContext context) async {
    RepairUserDB repairUserDB;
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    //var map = getPersonalInfoFromDB(token);
    var map = await getPersonalInfoFromDB(token);
    if (map == null) {
      var value = await getPersonalInfoFromInternet(context,token,false);
      return value;
    } else {
      repairUserDB = RepairUserDB.fromMap(map);
      if((new DateTime.now().millisecond - repairUserDB.time)>= _oneDayMilliSeconds){
        var value = await getPersonalInfoFromInternet(context, token,true);
        return value;
      }
      return repairUserDB;
    }

  }

  Future<RepairUserDB> getPersonalInfoFromInternet(BuildContext context,String token,bool updateDB) async{
    try{
      RepairUserDB repairUserDB;
      RequestManager.baseHeaders = {"token": token};
      ResultModel resultModel = await RequestManager.requestGet(
          HttpAddressMananger().personalInfo, null); //todo
      bool valid = await ApiRequest().handleResultModel(context, resultModel);
      if(valid){
        print(resultModel.data.toString());
        RepairsUser repairsUser =PersonalInfoResponse.fromJson(jsonDecode(resultModel.data.toString())).repairsUser;
        if(repairsUser.headimg==null){
          repairsUser.headimg = "assets/images/person_placeholder.png";
        }
        if(repairsUser.name==null){
          repairsUser.name = "用户姓名";
        }
        Map<String,dynamic> map = {
          "id":token,
          "userId":repairsUser.id,
          "name":repairsUser.name,
          "phone":repairsUser.phone.toString(),
          "headimg":repairsUser.headimg,
          "time":new DateTime.now().millisecond,
          "createTime":repairsUser.createTime,
          "updateTime":repairsUser.updateTime,
          "status":repairsUser.status
        };
        //insert or update the repairuser in DB
        repairUserDB = RepairUserDB.fromMap(map);
        //Map dbResult = await getPersonalInfoFromDB(token);
        if(!updateDB){
          await insertNewPersonalInfoIntoDB(token, map);
        }else{
          await updatePersonalInfoOnDb(map, token);
        }
        return repairUserDB;
      }
      return null;
    }on DioError catch(e){
      ApiRequest().handleDioError(e);
    }

  }

  //update name
  Future<bool> updateName(BuildContext context, String id, String userId,String newName)async{
    bool state = await updateNameOnInternet(context,userId, newName);
    if(state){
      var result = await updateNameOnDB(id, newName);
      if(result>=0){
        //RepairUserDB repairUserDB = RepairUserDB(id: id,name: name,headimg: file.path,time:new DateTime.now().millisecond );
        //return repairUserDB;
        Fluttertoast.showToast(msg: "昵称更新成功");
        return true;
      }
    }else{
      return false;
      //todo:更新失败
    }

  }

  Future<bool> updateNameOnInternet(BuildContext context,String userId,String newName) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    Options options = new Options();
    options.headers = {"token": token};
    try {
      Response response = await Dio().post(
          HttpAddressMananger().getUpdatePersonalInfoUrl(),
          options: options,
          data: {
            'id':userId,
            'name':newName
          });
      bool valid = await ApiRequest().handleResponse(context, response);
      if(valid){
        print("update name: "+response.toString());
        bool state = json.decode(response.toString()).cast<String, dynamic>()['state'];
        String msg = json.decode(response.toString()).cast<String, dynamic>()['msg'];
        Fluttertoast.showToast(msg: msg);
        return state;
      }
      //todo: handle response to decide if the name is updated successfully
    } on DioError catch (e) {
     ApiRequest().handleDioError(e);
    }
  }


  Future<int> updateNameOnDB(String id,String name)async{
    Database database = await getDB();
    Batch batch = database.batch();
    batch.update(tableName, {columnName:name},where: "$columnId=?", whereArgs: [id]);
    var results = await batch.commit();
    await database.close();
    return results[0];
  }


  //update image

  Future<bool> updateImage(BuildContext context,File file,String userId)async{
    String uploadImgUrl = await updateImageOnInternet(context,file, userId);
    if(uploadImgUrl!=null){
      var result = await updateImgOnDB(uploadImgUrl);
      if(result>=0){
        //RepairUserDB repairUserDB = RepairUserDB(id: id,name: name,headimg: file.path,time:new DateTime.now().millisecond );
        //return repairUserDB;
        Fluttertoast.showToast(msg: "头像更新成功");
        return true;
      }
    }else{
      //todo: if msg is "修改失败"
      return false;
    }
  }

  /*
  Future<int> updateImageOnDB(File file,String id,String name)async{
    var map = await getPersonalInfoFromDB(id);
    int result;
    if(map==null){
      result = await insertNewPersonalInfoIntoDB(id, name, file.path);
    }else{
      result = await updateImgOnDB(id,file.path);
    }
    return result;
  }*/

  Future<int> updateImgOnDB(String headimg)async{
    Database database = await getDB();
    Batch batch = database.batch();
    SharedPreferences sp = await SharedPreferences.getInstance();
    String token = sp.getString("token");
    batch.update(tableName, {columnHeadImg:headimg},where: "$columnId=?", whereArgs: [token]);
    var results = await batch.commit();

    /*var valueToUpdate = <String,dynamic>{
      columnId:id,
      columnName:name,
      columnHeadImg:headimg,
      columnTime:new DateTime.now().millisecond
    };
    var returnedId = await database.update(
        tableName,
        valueToUpdate,
        where: "$columnId=?",
        whereArgs: [id]
    );*/
    await database.close();
    return results[0];
  }


  Future<String> updateImageOnInternet(BuildContext context,File file,String userId)async {
    Dio dio = new Dio();
    FormData formData = new FormData.from({
      "file": new UploadFileInfo(file, file.path),
    });
    Response response = await dio.post(
      HttpAddressMananger().getUploadImgUrl(),
      data: formData,
    );

    bool valid = await ApiRequest().handleResponse(context, response);
    if(valid){
      print("upload image to server: "+response.toString());
      SharedPreferences sp = await SharedPreferences.getInstance();
      String token = sp.getString("token");
      RequestManager.baseHeaders = {"token": token};
      ResultModel resultModel = await RequestManager.requestPost(
          HttpAddressMananger().updatePersonalInfo,
          {"id": userId, "headimg": json.decode(response.toString())['data']['url']});
      //todo
      /*
    {"msg":"运行异常，请联系管理员","code":500,"state":false}
     */
      bool result = await ApiRequest().handleResultModel(context, resultModel);
      if(result){
        print("update personal info: "+resultModel.data.toString());
        //bool state = json.decode(resultModel.data.toString()).cast<String, dynamic>()['state'];
        String msg = json.decode(resultModel.data.toString()).cast<String, dynamic>()['msg'];
        Fluttertoast.showToast(msg: msg);
        return json.decode(response.toString())['data']['url'];
      }
      return null;
    }else{
      return null;
    }
  }


//todo: CRUD
   final String dbName = 'personal_info.db';
   final String tableName = "my_personal_info";
   final String columnId = "id";
   final String columnUserId = 'userId';
   final String columnPhone = 'phone';
   final String columnName = "name";
   final String columnHeadImg = "headimg";
   final String columnTime = "time";
   final String columnCreateTime = 'createTime';
   final String columnUpdateTime ='updateTime';
   //final String columnOpenId = 'openId';
   final String columnStatus = 'status';


  Future<Database> getDB()async{
    var databasePath = await getDatabasesPath();
    String path = join(databasePath,dbName);
    var database = await openDatabase(
        path,
        version: 1,
        onCreate: (db,version)async{
          return db.execute(
              "CREATE TABLE $tableName($columnId STRING PRIMARY KEY, $columnUserId String,$columnPhone String, $columnName TEXT,$columnHeadImg String,$columnTime INTEGER,$columnCreateTime String,$columnUpdateTime String,$columnStatus INTEGER )"
          );
        }
    );    //$columnOpenId String,
    return database;
  }
  //todo:personal info
  //query database
  Future<Map<String,dynamic>> getPersonalInfoFromDB(String id) async{
    Database database = await getDB();
    List<Map<String, dynamic>> list = await database.query(
      tableName,
      columns: [columnId,columnUserId,columnName,columnPhone,columnHeadImg,columnTime,columnCreateTime,columnUpdateTime,columnStatus],
      where: "$columnId=?",
      whereArgs: [id]
    );
    await database.close();
    if(list.isEmpty){
      return null;
    }
    return list.first;
  }


  //todo
  //insert into database
  Future<int> insertNewPersonalInfoIntoDB(String id, Map map)async{
    Database database = await getDB();
    var returnedId = await database.insert(tableName, map);
    await database.close();
    return returnedId;
  }

  Future<int> updatePersonalInfoOnDb(Map map,String token)async{
    Database database = await getDB();
    int result = await database.update(tableName, map, where: "$columnId=?", whereArgs: [token]);
    await database.close();
    return result;
  }

  //delete in database

  Future<int> deletePersonalInfoFromDB(String id) async{
    Database database = await getDB();
    var returnedId = await database.delete(
        tableName,
        where: "$columnId=?",
        whereArgs: [id]
    );
    await database.close();
    return returnedId;
  }



}