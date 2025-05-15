import '../../Domain/Entities/voucher_entites.dart';
import '../../Domain/Repositories/voucher_repositories.dart';
import '../Sources/voucher_remote_source.dart';

class VoucherRepositoryImpl implements VoucherRepository {
  final VoucherRemoteDataSource remoteDataSource;

  VoucherRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<VoucherEntity>> getVouchers() async {
    return await remoteDataSource.fetchVouchers();
  }
}
