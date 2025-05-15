import '../Entities/attendance_form_entities.dart';
import '../Repositories/attendance_form_repositories.dart';

class AttendanceFormUseCase {
  final AttendanceFormRepository repository;

  AttendanceFormUseCase({required this.repository});

  Future<void> createAttendance(AttendanceFormEntities attendance) async {
    return await repository.createAttendance(attendance);
  }
}
