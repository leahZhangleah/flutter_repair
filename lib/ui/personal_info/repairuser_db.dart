class RepairUserDB{
  String id;
  String userId;
  String phone;
  String name;
  String headimg;
  int time;//local create time
  String createTime;//account create time
  String updateTime;//internet info update time
  //String openId;
  int status;


  RepairUserDB(this.id,this.userId,this.phone, this.name, this.headimg, this.time,
      this.createTime, this.updateTime,  this.status);//this.openId,



  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId':userId,
      'phone':phone,
      'name': name,
      'headimg': headimg,
      'time':time,
      'createTime':createTime,
      'updateTime':updateTime,
      //'openid':openId,
      'status':status
    };
  }

  RepairUserDB.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    userId = map['userId'];
    phone = map['phone'].toString();
    name = map['name'];
    headimg = map['headimg'];
    time = map['time'];
    createTime=map['createTime'];
    updateTime = map['updateTime'];
    //openId=map['openid'];
    status=map['status'];

  }
}