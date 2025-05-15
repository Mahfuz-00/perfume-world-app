import '../Entities/employee_entities.dart';

abstract class EmployeeRepository {
  Future<List<EmployeeEntity>> getEmployees();
}
