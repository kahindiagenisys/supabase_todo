class AuthInfo {
  String? id;
  String? email;
  String? password;
  String? token;

  AuthInfo({
    this.id,
    this.email,
    this.password,
    this.token,
  });

  AuthInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['password'] = password;
    data['token'] = token;
    return data;
  }

  AuthInfo copyWith({
    String? id,
    String? email,
    String? password,
    String? token,
    bool? isOwner,
  }) =>
      AuthInfo(
        id: id ?? this.id,
        email: email ?? this.email,
        password: password ?? this.password,
        token: token ?? this.token,
      );
}
