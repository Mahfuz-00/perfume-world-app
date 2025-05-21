import '../../Domain/Entities/customer_entities.dart';
import '../../Domain/Repositories/customer_repositories.dart';
import '../Sources/customer_remote_source.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDataSource remoteDataSource;

  CustomerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Customer>> getCustomers() async {
    try {
      return await remoteDataSource.getCustomers();
    } catch (e) {
      throw Exception('Failed to fetch customers: $e');
    }
  }

  @override
  Future<Customer> addCustomer(String name, String phone) async {
    try {
      return await remoteDataSource.addCustomer(name, phone);
    } catch (e) {
      throw Exception('Failed to add customer: $e');
    }
  }
}