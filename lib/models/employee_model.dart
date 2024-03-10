class Employee {
  final String Employee_code;
  final String Email;
  final String Password;

  const Employee({
    required this.Employee_code,
    required this.Email,
    required this.Password,
  });

  Map<String, dynamic> mapUser() {
    return {
      'Employee_code': Employee_code,
      'Email': Email,
      'Password': Password,
    };
  }
}
