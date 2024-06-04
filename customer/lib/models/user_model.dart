class UserModel {
  final String username;
  final String name;
  final String email;
  final String phone;

  UserModel.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        name = json['name'],
        email = json['email'],
        phone = json['phone'];
}