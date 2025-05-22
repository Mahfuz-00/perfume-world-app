
import '../Entities/payment_entities.dart';

abstract class PaymentMethodRepository {
  Future<List<PaymentMethod>> getPaymentMethods();
}