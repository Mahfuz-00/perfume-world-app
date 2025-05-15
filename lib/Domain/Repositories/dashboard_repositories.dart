import '../Entities/dashboard_entities.dart';

abstract class DashboardRepository {
  Future<DashboardEntity> getDashboardData();
}
