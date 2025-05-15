part of 'leave_bloc.dart';

abstract class LeaveEvent {}

class LoadLeaveApplications extends LeaveEvent {
  final String? status;

  LoadLeaveApplications({this.status});
}
