class MaintainerDescriptionList{
  String id;
  String maintainerOrdersId;
  String fileName;
  String url;
  int type;

  MaintainerDescriptionList(
      {this.id, this.maintainerOrdersId, this.fileName, this.url, this.type});

  MaintainerDescriptionList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    maintainerOrdersId = json['repairsOrdersId'];
    fileName = json['fileName'];
    url = json['url'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['repairsOrdersId'] = this.maintainerOrdersId;
    data['fileName'] = this.fileName;
    data['url'] = this.url;
    data['type'] = this.type;
    return data;
  }
}