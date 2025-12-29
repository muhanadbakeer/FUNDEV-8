class UserModel {
  String? accessToken;
  String? refreshToken;
  int? id;
  String? username;
  String? email;
  String? phone;
  String? role;

  UserModel({
    this.accessToken,
    this.refreshToken,
    this.id,
    this.username,
    this.email,
    this.phone,
    this.role,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    id = json['id'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['refresh_token'] = this.refreshToken;
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['role'] = this.role;
    return data;
  }
}
