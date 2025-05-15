part of 'activity_form_bloc.dart';

abstract class ActivityFormState extends Equatable {
  const ActivityFormState();

  @override
  List<Object?> get props => [];
}

class ActivityFormInitial extends ActivityFormState {}

class ActivityFormLoading extends ActivityFormState {
  @override
  String toString() => 'ActivityFormLoading';
}

class ActivityFormSuccess extends ActivityFormState {
  @override
  String toString() => 'ActivityFormSuccess';
}



class ActivityFormFailure extends ActivityFormState {
  final String error;

  const ActivityFormFailure(this.error);

  @override
  List<Object?> get props => [error];
}
