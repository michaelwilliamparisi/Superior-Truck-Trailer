class Work_Orders {
  final String Work_order_num;
  final String Emp_num;
  final String Trailer_num;
  final String Company_name;
  final String Job_codes;
  final String parts;
  final String labour;

  const Work_Orders({
    required this.Work_order_num,
    required this.Emp_num,
    required this.Trailer_num,
    required this.Company_name,
    required this.Job_codes,
    required this.parts,
    required this.labour,
  });

  Map<String, dynamic> mapUser() {
    return {
      'Work_order_num': Work_order_num,
      'Emp_num': Emp_num,
      'Trailer_num': Trailer_num,
      'Company_name': Company_name,
      'Job_codes': Job_codes,
      'parts': parts,
      'labour': labour,
    };
  }
}
