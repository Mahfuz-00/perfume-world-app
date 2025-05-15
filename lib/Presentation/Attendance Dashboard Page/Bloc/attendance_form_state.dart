part of 'attendance_form_bloc.dart';

abstract class AttendanceFormState {}

class AttendanceInitial extends AttendanceFormState {}

class AttendanceFormLoading extends AttendanceFormState {}

class AttendanceSubmitted extends AttendanceFormState {}

class AttendanceFormFailure extends AttendanceFormState {
  final String error;

  AttendanceFormFailure({required this.error});

  @override
  List<Object?> get props => [error];
}


