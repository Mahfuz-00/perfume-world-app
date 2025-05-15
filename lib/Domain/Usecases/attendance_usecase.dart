import '../Entities/attendance_entities.dart';
import '../Repositories/attendance_repositories.dart';

class GetAttendanceRequestsUseCase {
  final AttendanceRepository repository;

  GetAttendanceRequestsUseCase({required this.repository});

  Future<List<AttendanceRequest>> call() async {
    return await repository.getAttendanceRequests();
  }
}
