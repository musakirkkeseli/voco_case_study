class AuthUnsuccessfulResponseModel {
  String? error;

  AuthUnsuccessfulResponseModel({this.error});

  AuthUnsuccessfulResponseModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    return data;
  }
}
