import '../../Domain/Entities/attendance_form_entities.dart';
import '../../Domain/Repositories/attendance_form_repositories.dart';
import '../Models/attendance_form.dart';
import '../Sources/attendance_form_remote_source.dart';

class AttendanceFormRepositoryImpl implements AttendanceFormRepository {
  final AttendanceFormRemoteDataSource remoteDataSource;

  // Constructor
  AttendanceFormRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createAttendance(AttendanceFormEntities attendance) async {
    // Convert domain entity (Attendance) to data model (AttendanceModel)
    final attendanceModel = AttendanceFormModel(
      inTime: attendance.entryTime,
      costCenterId: attendance.project,
      description: attendance.remark,
    );

    // Pass the data model to the remote data source for actual network request
    await remoteDataSource.createAttendance(attendanceModel);
  }
}
