import '../../Domain/Entities/employee_entities.dart';

class EmployeeModel extends EmployeeEntity {
  const EmployeeModel({
    required int id,
    required String name,
  }) : super(id: id, name: name);

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
