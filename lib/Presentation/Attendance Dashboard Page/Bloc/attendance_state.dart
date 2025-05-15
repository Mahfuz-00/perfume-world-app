part of 'attendance_bloc.dart';

abstract class AttendanceState {}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {
  final List<AttendanceRequest> attendances;

  AttendanceLoaded(this.attendances);
}

class AttendanceError extends AttendanceState {
  final String message;

  AttendanceError(this.message);
}

