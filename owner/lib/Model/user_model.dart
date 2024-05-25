class UserModel {
  final String username;
  final String name;
  final String email;
  final String password;

  UserModel.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        name = json['name'],
        email = json['enmail'],
        password = json['password'];
}
