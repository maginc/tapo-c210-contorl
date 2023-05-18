class AuthorizationResponse {
  int? errorCode;
  Result? result;

  AuthorizationResponse({this.errorCode, this.result});

  AuthorizationResponse.fromJson(Map<String, dynamic> json) {
    errorCode = json['error_code'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error_code'] = this.errorCode;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? stok;
  String? userGroup;

  Result({this.stok, this.userGroup});

  Result.fromJson(Map<String, dynamic> json) {
    stok = json['stok'];
    userGroup = json['user_group'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stok'] = this.stok;
    data['user_group'] = this.userGroup;
    return data;
  }
}