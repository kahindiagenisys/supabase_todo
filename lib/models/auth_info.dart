class AuthInfo {
  String? id;
  String? email;
  String? password;
  String? token;
  String? profilePic;

  AuthInfo({
    this.id,
    this.email,
    this.password,
    this.token,
    this.profilePic,
  });

  AuthInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    token = json['token'];
    profilePic = json['profile_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['password'] = password;
    data['token'] = token;
    data['profile_pic'] = profilePic;
    return data;
  }

  AuthInfo copyWith({
    String? id,
    String? email,
    String? password,
    String? token,
    bool? isOwner,
    String? profilePic,
  }) =>
      AuthInfo(
        id: id ?? this.id,
        email: email ?? this.email,
        password: password ?? this.password,
        token: token ?? this.token,
        profilePic: profilePic ?? this.profilePic,
      );
}
