part of 'employee_bloc.dart';

abstract class EmployeeState {}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<EmployeeEntity> employees;

  EmployeeLoaded({required this.employees});
}

class EmployeeError extends EmployeeState {
  final String error;

  EmployeeError({required this.error});
}

