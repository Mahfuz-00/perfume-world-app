import '../Repositories/customer_repositories.dart';

class GetCustomers {
  final CustomerRepository repository;

  GetCustomers(this.repository);

  Future<List> call() async {
    return await repository.getCustomers();
  }
}