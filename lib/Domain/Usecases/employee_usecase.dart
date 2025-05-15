import '../Entities/employee_entities.dart';
import '../Repositories/employee_repositories.dart';

class GetEmployeesUseCase {
  final EmployeeRepository repository;

  GetEmployeesUseCase({required this.repository});

  Future<List<EmployeeEntity>> call() async {
    return await repository.getEmployees();
  }
}

