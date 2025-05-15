part of 'signout_bloc.dart';

abstract class SignOutState {}

class SignOutInitial extends SignOutState {}

class SignOutLoading extends SignOutState {}

class SignedOut extends SignOutState {}

class SignOutError extends SignOutState {
  final String error;
  SignOutError(this.error);
}
