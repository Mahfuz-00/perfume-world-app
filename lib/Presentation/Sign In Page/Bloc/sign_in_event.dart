part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class PerformSignInEvent extends SignInEvent {
  final String username;
  final String password;
  final bool rememberMe; // Add rememberMe here

  const PerformSignInEvent({
    required this.username,
    required this.password,
    this.rememberMe = false, // Default to false if not provided
  });

  @override
  List<Object> get props => [username, password, rememberMe];
}
