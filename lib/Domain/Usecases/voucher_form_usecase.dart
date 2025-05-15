import '../Entities/voucher_form_entities.dart';
import '../Repositories/voucher_form_repositories.dart';

class SubmitVoucherFormUseCase {
  final VoucherFormRepository repository;

  SubmitVoucherFormUseCase(this.repository);

  Future<void> call(VoucherFormEntity formEntity) async {
    // Handle logic of submitting voucher form
    await repository.submitVoucherForm(formEntity);
  }
}

