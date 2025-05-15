import '../Entities/dashboard_entities.dart';
import '../Repositories/dashboard_repositories.dart';

class GetDashboardDataUseCase {
  final DashboardRepository repository;

  GetDashboardDataUseCase({required this.repository});

  Future<DashboardEntity> call() async {
    return await repository.getDashboardData();
  }
}
