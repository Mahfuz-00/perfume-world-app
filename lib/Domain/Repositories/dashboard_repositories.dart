import 'package:perfume_world_app/Domain/Entities/product_entities.dart';

import '../Entities/dashboard_entities.dart';

abstract class DashboardRepository {
  Future<List<ProductEntity>> getDashboardData();
}
