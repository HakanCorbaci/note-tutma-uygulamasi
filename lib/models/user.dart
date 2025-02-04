class User {
  late int? id;
  late String username;
  late String email;
  late String? password;

  User({
    this.id,
    required this.username,
    required this.email,
    this.password,
  });

  toMap() => {'username': username, 'email': email, 'password': password!};
  static User fromMap(Map map) => User(
        id: map['id'],
        username: map['username'],
        email: map['email'],
      );
}
