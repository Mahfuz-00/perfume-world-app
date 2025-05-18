import 'package:perfume_world_app/Domain/Entities/product_entities.dart';

import '../Entities/dashboard_entities.dart';
import '../Repositories/dashboard_repositories.dart';

class GetDashboardDataUseCase {
  final DashboardRepository repository;

  GetDashboardDataUseCase({required this.repository});

  Future<List<ProductEntity>> call() async {
    return await repository.getDashboardData();
  }
}
