class PriortyIssue {
  final int? idPriority;
  final String? priorityName;

  // "id_priority": 1,
  // "priority_name": "Critical",

  const PriortyIssue({
    this.idPriority,
    this.priorityName,
  });

  factory PriortyIssue.fromJson(Map<String, dynamic> json) {
    return PriortyIssue(
      // sesuaikan dengan response json
      idPriority: json['id_priority'],
      priorityName: json['priority_name'],
    );
  }
  // Map<String, dynamic> toJson() => {
  //       //sesuaikan dengan response json yang diterima
  //       "id_division_target": idDivisionTarget,
  //       "division_target": divisionTarget,
  //       "division_department_name": divisionDepartmentName,
  //     };
}
