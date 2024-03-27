class Employee {
  final String Employee_code;
  final String Email;
  final String Password;
  // final String Fname;
  // final String Lname;

  const Employee({
    required this.Employee_code,
    required this.Email,
    required this.Password,
    // required this.Fname,
    // required this.Lname,
  });

  Map<String, dynamic> mapUser() {
    return {
      'Employee_code': Employee_code,
      'Email': Email,
      'Password': Password,
      // 'Fname': Fname,
    };
  }
}
