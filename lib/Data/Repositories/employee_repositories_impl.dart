import '../../Domain/Entities/employee_entities.dart';
import '../../Domain/Repositories/employee_repositories.dart';
import '../Models/employee.dart';
import '../Sources/employee_remote_source.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeRemoteDataSource remoteDataSource;

  EmployeeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<EmployeeEntity>> getEmployees() async {
    final employees = await remoteDataSource.fetchEmployees();
    return employees.map((e) => EmployeeModel.fromJson(e)).toList();
  }
}
