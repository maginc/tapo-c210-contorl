class Authorization {
  String? method;
  Params? params;

  Authorization({this.method, this.params});

  Authorization.fromJson(Map<String, dynamic> json) {
    method = json['method'];
    params =
    json['params'] != null ? new Params.fromJson(json['params']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['method'] = this.method;
    if (this.params != null) {
      data['params'] = this.params!.toJson();
    }
    return data;
  }
}

class Params {
  String? hashed;
  String? password;
  String? username;

  Params({this.hashed, this.password, this.username});

  Params.fromJson(Map<String, dynamic> json) {
    hashed = json['hashed'];
    password = json['password'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hashed'] = this.hashed;
    data['password'] = this.password;
    data['username'] = this.username;
    return data;
  }
}