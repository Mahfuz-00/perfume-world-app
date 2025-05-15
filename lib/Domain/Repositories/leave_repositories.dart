import '../Entities/leave_entities.dart';

abstract class LeaveRepository {
  Future<List<LeaveEntity>> getLeaveApplications();
}
