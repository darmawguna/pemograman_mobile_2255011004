class DivisionDepartment {
  final int? idDivisionTarget;
  final String? divisionTarget;
  final String? divisionDepartmentName;
  //   "id_division_target": 1,
  // "division_target": "BILLING",
  // "division_department_name": "Finance Department",

  const DivisionDepartment({
    this.idDivisionTarget,
    this.divisionTarget,
    this.divisionDepartmentName,
  });

  factory DivisionDepartment.fromJson(Map<String, dynamic> json) {
    return DivisionDepartment(
      // sesuaikan dengan response json
      idDivisionTarget: json['id_division_target'],
      divisionTarget: json['division_target'],
      divisionDepartmentName: json['division_department_name'],
    );
  }
  Map<String, dynamic> toJson() => {
        //sesuaikan dengan response json yang diterima
        "id_division_target": idDivisionTarget,
        "division_target": divisionTarget,
        "division_department_name": divisionDepartmentName,
      };
}
