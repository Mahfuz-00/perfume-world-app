import '../Entities/leave_entities.dart';
import '../Repositories/leave_repositories.dart';

class GetLeaveUseCase {
  final LeaveRepository repository;

  GetLeaveUseCase({required this.repository});

  Future<List<LeaveEntity>> call() async {
    return await repository.getLeaveApplications();
  }
}
