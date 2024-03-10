class User {

  final int id;
  final String email;
  final String password;


  const User ({
    required this.id,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> mapUser() {
    return {
      'id': id,
      'email': email,
      'password': password,
    };
  }
}