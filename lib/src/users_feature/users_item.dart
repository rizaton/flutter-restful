/// A placeholder class that represents an entity or model.
class UsersItem {
  const UsersItem({
    required this.id,
    required this.name,
    required this.username,
    required this.password,
    required this.access,
  });

  final int id;
  final String name;
  final String username;
  final String password;
  final int access;

  factory UsersItem.fromJson(Map<String, dynamic> json) {
    return UsersItem(
      id: int.parse(json['id']),
      name: json['name'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      access: int.parse(json['access']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'password': password,
      'access': access,
    };
  }
}
