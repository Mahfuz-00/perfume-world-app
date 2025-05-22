import '../../Domain/Entities/payment_entities.dart';
import '../../Domain/Repositories/payment_repositories.dart';
import '../Sources/payment_remote_source.dart';


class PaymentMethodRepositoryImpl implements PaymentMethodRepository {
  final PaymentMethodRemoteDataSource remoteDataSource;

  PaymentMethodRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<PaymentMethod>> getPaymentMethods() async {
    try {
      final models = await remoteDataSource.getPaymentMethods();
      return models; 
    } catch (e) {
      throw Exception('Failed to fetch payment methods: $e');
    }
  }
}