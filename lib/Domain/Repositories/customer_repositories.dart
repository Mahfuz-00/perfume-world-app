import '../Entities/customer_entities.dart';

abstract class CustomerRepository {
  Future<List<Customer>> getCustomers();
  Future<Customer> addCustomer(String name, String phone);
}