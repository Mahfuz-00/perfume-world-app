part of 'leave_form_bloc.dart';


abstract class LeaveFormState {}

class LeaveFormInitial extends LeaveFormState {}

class LeaveFormLoading extends LeaveFormState {}

class LeaveFormSuccess extends LeaveFormState {}

class LeaveFormFailure extends LeaveFormState {
  final String error;

  LeaveFormFailure(this.error);

  @override
  List<Object?> get props => [error];
}
