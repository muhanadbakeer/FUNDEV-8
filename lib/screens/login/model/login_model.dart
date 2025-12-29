import 'package:div/screens/login/model/user_model.dart';

class LoginModel {
  bool? result;
  UserModel? data;

  LoginModel({this.result, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    data = json['data'] != null ? new UserModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

