class User {
  final String login;
  final String password;
  final bool token;
  User(this.login, this.password, this.token);

  Map<String, dynamic> toJson() => {
    'login': login,
    'password': password,
    'token': token,
  };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['login'] as String, json['password'] as String,
        json['token'] as bool);
  }
}