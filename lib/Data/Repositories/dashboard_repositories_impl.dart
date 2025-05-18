import 'package:perfume_world_app/Domain/Entities/product_entities.dart';

import '../../Domain/Entities/dashboard_entities.dart';
import '../../Domain/Repositories/dashboard_repositories.dart';
import '../Sources/dashboard_remote_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteSource remoteSource;

  DashboardRepositoryImpl({required this.remoteSource});

  @override
  Future<List<ProductEntity>> getDashboardData() async {
    return await remoteSource.fetchDashboardData();
  }
}
