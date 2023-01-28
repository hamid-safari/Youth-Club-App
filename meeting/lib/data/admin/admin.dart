class Admin {
  final String username;
  final String password;

  Admin({
    required this.username,
    required this.password,
  });

  Admin.fromJson(Map<String, dynamic> data)
      : username = data['username'],
        password = data['password'];
}
