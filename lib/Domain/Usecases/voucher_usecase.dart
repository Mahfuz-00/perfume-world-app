import '../Entities/voucher_entites.dart';
import '../Repositories/voucher_repositories.dart';

class GetVouchers {
  final VoucherRepository repository;

  GetVouchers({required this.repository});

  Future<List<VoucherEntity>> call() async {
    return await repository.getVouchers();
  }
}
