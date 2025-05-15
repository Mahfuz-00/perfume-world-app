part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {
  final String token; // Store the token in the success state

  const SignInSuccess(this.token);

  @override
  List<Object> get props => [token];
}

class SignInFailure extends SignInState {
  final String error;

  const SignInFailure(this.error);

  @override
  List<Object> get props => [error];
}
