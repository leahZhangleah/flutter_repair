class RegisterResponse{

//  {
//  "msg": "success",
//  "code": 0,
//  "state": true
//  }

    String msg;
    int code;
    bool state;

    RegisterResponse({this.msg, this.code, this.state});

    factory RegisterResponse.fromJson(Map<String, dynamic> json) {
      return RegisterResponse(
        msg: json['msg'],
        code: json['code'],
        state: json['state'],
      );
    }
}