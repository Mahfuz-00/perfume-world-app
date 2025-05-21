
import '../Repositories/customer_repositories.dart';

class AddCustomer {
  final CustomerRepository repository;

  AddCustomer(this.repository);

  Future call(String name, String phone) async {
    return await repository.addCustomer(name, phone);
  }
}