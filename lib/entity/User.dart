class User{

  String account;
  String password;

  String token;

  User({this.account, this.password, this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      account: json['account'],
      password: json['password'],
      token: json['token'],
    );
  }



}