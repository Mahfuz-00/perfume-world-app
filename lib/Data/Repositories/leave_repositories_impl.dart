import '../../Domain/Entities/leave_entities.dart';
import '../../Domain/Repositories/leave_repositories.dart';
import '../Sources/leave_remote_source.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final LeaveRemoteSource remoteSource;

  LeaveRepositoryImpl({required this.remoteSource});

  @override
  Future<List<LeaveEntity>> getLeaveApplications() async {
    try {
      // Fetch the LeaveModel from the remote source
      final leaveModel = await remoteSource.fetchLeaveApplications();

      // Convert the LeaveModel to LeaveEntity and return a list
      return [
        LeaveEntity(
          remainingDays: leaveModel.remainingDays,
          leaveRecords: leaveModel.leaveRecords.map((e) => e.toEntity()).toList(),
        ),
      ];
    } catch (e) {
      throw Exception('Error fetching leave applications: $e');
    }
  }
}

