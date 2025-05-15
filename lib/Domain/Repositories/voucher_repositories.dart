import '../Entities/voucher_entites.dart';

abstract class VoucherRepository {
  Future<List<VoucherEntity>> getVouchers();
}
