class QuoteUser {
  String id;
  String parentId;
  String phone;
  String password;
  String salt;
  String name;
  String headimg;
  int type;
  int authentication;
  String lastLoginTime;
  String createTime;
  String updateTime;
  int status;
  String openid;

  QuoteUser(
      {this.id,
        this.parentId,
        this.phone,
        this.password,
        this.salt,
        this.name,
        this.headimg,
        this.type,
        this.authentication,
        this.lastLoginTime,
        this.createTime,
        this.updateTime,
        this.status,
        this.openid});

  QuoteUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parentId'];
    phone = json['phone'];
    password = json['password'];
    salt = json['salt'];
    name = json['name'];
    headimg = json['headimg'];
    type = json['type'];
    authentication = json['authentication'];
    lastLoginTime = json['lastLoginTime'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    status = json['status'];
    openid = json['openid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parentId'] = this.parentId;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['salt'] = this.salt;
    data['name'] = this.name;
    data['headimg'] = this.headimg;
    data['type'] = this.type;
    data['authentication'] = this.authentication;
    data['lastLoginTime'] = this.lastLoginTime;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['status'] = this.status;
    data['openid'] = this.openid;
    return data;
  }
}