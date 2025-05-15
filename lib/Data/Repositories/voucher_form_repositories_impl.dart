import '../../Domain/Entities/voucher_form_entities.dart';
import '../../Domain/Repositories/voucher_form_repositories.dart';
import '../Models/voucher_form.dart';
import '../Sources/voucher_form_remote_source.dart';

class VoucherFormRepositoryImpl implements VoucherFormRepository {
  final VoucherFormRemoteDataSource remoteDataSource;

  VoucherFormRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> submitVoucherForm(VoucherFormEntity formEntity) async {
    final model = VoucherFormModel.fromEntity(formEntity);
    await remoteDataSource.submitVoucherForm(model.toJson());
  }
}
