import '../Entities/customer_entities.dart';

abstract class CustomerRepository {
  Future<List<Customer>> getCustomers();
  Future<String> addCustomer(String name, String phone);
}