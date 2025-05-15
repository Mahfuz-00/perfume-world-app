part of 'activity_form_bloc.dart';

abstract class ActivityFormEvent extends Equatable {
  const ActivityFormEvent();

  @override
  List<Object?> get props => [];
}

class SubmitActivityEvent extends ActivityFormEvent {
  final ActivityFromEntity activity;

  const SubmitActivityEvent(this.activity);

  @override
  List<Object?> get props => [activity];
}
