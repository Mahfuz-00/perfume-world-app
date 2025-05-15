part of 'leave_form_bloc.dart';

abstract class LeaveFormEvent {}

class SubmitLeaveFormEvent extends LeaveFormEvent {
  final LeaveFormEntity leaveForm;

  SubmitLeaveFormEvent(this.leaveForm);
}




