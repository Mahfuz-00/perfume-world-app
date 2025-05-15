part of 'attendance_form_bloc.dart';

@immutable
abstract class AttendanceFormEvent {}

class CreateAttendanceEvent extends AttendanceFormEvent {
  final AttendanceFormEntities attendanceForm;

  CreateAttendanceEvent(this.attendanceForm);
}
