class OrdersAppraise {
  String id;
  String ordersId;
  String content;
  String replyContent;
  int isSolve;
  int starLevel;
  String createUser;
  String updateUser;
  String createTime;
  String updateTime;
  int status;

  OrdersAppraise(
      {this.id,
        this.ordersId,
        this.content,
        this.replyContent,
        this.isSolve,
        this.starLevel,
        this.createUser,
        this.updateUser,
        this.createTime,
        this.updateTime,
        this.status});

  OrdersAppraise.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ordersId = json['ordersId'];
    content = json['content'];
    replyContent = json['replyContent'];
    isSolve = json['isSolve'];
    starLevel = json['starLevel'];
    createUser = json['createUser'];
    updateUser = json['updateUser'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ordersId'] = this.ordersId;
    data['content'] = this.content;
    data['replyContent'] = this.replyContent;
    data['isSolve'] = this.isSolve;
    data['starLevel'] = this.starLevel;
    data['createUser'] = this.createUser;
    data['updateUser'] = this.updateUser;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    data['status'] = this.status;
    return data;
  }
}