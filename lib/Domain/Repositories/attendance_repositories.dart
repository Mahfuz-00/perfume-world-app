import '../Entities/attendance_entities.dart';

abstract class AttendanceRepository {
  Future<List<AttendanceRequest>> getAttendanceRequests();
}

