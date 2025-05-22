// lib/domain/usecases/get_payment_methods.dart
import '../Entities/payment_entities.dart';
import '../Repositories/payment_repositories.dart';

class GetPaymentMethods {
  final PaymentMethodRepository repository;

  GetPaymentMethods(this.repository);

  Future<List<PaymentMethod>> call() async {
    return await repository.getPaymentMethods();
  }
}