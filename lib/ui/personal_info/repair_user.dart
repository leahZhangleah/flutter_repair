class RepairsUser {
  String id;
  String phone;
  String name;
  String headimg;
  String lastLoginTime;
  String createTime;
  String updateTime;
  int status;

  RepairsUser(
      {this.id,
        this.phone,
        this.name,
        this.headimg,
        this.lastLoginTime,
        this.createTime,
        this.updateTime,
        this.status});

  RepairsUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    name = json['name'];
    headimg = json['headimg'];
    lastLoginTime = json['lastLoginTime'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['headimg'] = this.headimg;
    data['lastLoginTime'] = this.lastLoginTime;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['status'] = this.status;
    return data;
  }
}