part of 'leave_bloc.dart';

abstract class LeaveState {}

class LeaveApplicationInitial extends LeaveState {}

class LeaveApplicationLoading extends LeaveState {}

class LeaveApplicationLoaded extends LeaveState {
  final List<LeaveEntity> leaveApplications;

  LeaveApplicationLoaded({required this.leaveApplications});
}

class LeaveApplicationError extends LeaveState {
  final String message;

  LeaveApplicationError({required this.message});
}
