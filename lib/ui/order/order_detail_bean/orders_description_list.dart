class OrdersDescriptionList{
  String id;
  String repairsOrdersId;
  String fileName;
  String url;
  int type;

  OrdersDescriptionList(
      {this.id, this.repairsOrdersId, this.fileName, this.url, this.type});

  OrdersDescriptionList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    repairsOrdersId = json['repairsOrdersId'];
    fileName = json['fileName'];
    url = json['url'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['repairsOrdersId'] = this.repairsOrdersId;
    data['fileName'] = this.fileName;
    data['url'] = this.url;
    data['type'] = this.type;
    return data;
  }
}