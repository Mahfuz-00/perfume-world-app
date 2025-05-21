// lib/presentation/blocs/customer/customer_event.dart
abstract class CustomerEvent {}

class FetchCustomers extends CustomerEvent {}

class AddCustomerEvent extends CustomerEvent {
  final String name;
  final String phone;

  AddCustomerEvent({required this.name, required this.phone});
}