import 'repair_user.dart';
class PersonalInfoResponse {
  String msg;
  int code;
  RepairsUser repairsUser;
  String fileUploadServer;
  bool state;

  PersonalInfoResponse(
      {this.msg,
        this.code,
        this.repairsUser,
        this.fileUploadServer,
        this.state});

  PersonalInfoResponse.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    code = json['code'];
    repairsUser = json['repairsUser'] != null
        ? new RepairsUser.fromJson(json['repairsUser'])
        : null;
    fileUploadServer = json['fileUploadServer'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    if (this.repairsUser != null) {
      data['repairsUser'] = this.repairsUser.toJson();
    }
    data['fileUploadServer'] = this.fileUploadServer;
    data['state'] = this.state;
    return data;
  }
}