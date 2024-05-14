

class CustomerService {
  final int? idCustomerService;
  final String? titleIssue;
  final String? descriptionIssues;
  final int? rating;
  final String? image;
  final int? idDivisionTarget;
  final int? idPriority;
  final String? divisionDepartmentName;
  final String? priorityName;

  const CustomerService({
    this.idCustomerService,
    this.titleIssue,
    this.descriptionIssues,
    this.rating,
    this.image,
    this.idDivisionTarget,
    this.idPriority,
    this.divisionDepartmentName,
    this.priorityName,
  });

  factory CustomerService.fromJson(Map<String, dynamic> json) {
    return CustomerService(
      // sesuaikan dengan response json
      idCustomerService: json['id_customer_service'],
      titleIssue: json['title_issues'],
      descriptionIssues: json['description_issues'],
      rating: json['rating'],
      image: json['image_url'],
      idDivisionTarget: json['id_division_target'],
      idPriority: json['id_priority'],
      divisionDepartmentName: json['division_department_name'],
      priorityName: json['priority_name'],
    );
  }
}
