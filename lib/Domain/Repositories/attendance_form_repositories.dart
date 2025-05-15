import '../../Data/Models/attendance_form.dart';
import '../Entities/attendance_form_entities.dart';

abstract class AttendanceFormRepository {
  Future<void> createAttendance(AttendanceFormEntities attendance);
}


