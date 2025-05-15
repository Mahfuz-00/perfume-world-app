import '../Entities/voucher_form_entities.dart';

abstract class VoucherFormRepository {
  Future<void> submitVoucherForm(VoucherFormEntity formEntity);
}
