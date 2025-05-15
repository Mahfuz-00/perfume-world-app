part of 'headofaccounts_bloc.dart';

abstract class ExpenseHeadState {}

class ExpenseHeadInitial extends ExpenseHeadState {}

class ExpenseHeadLoading extends ExpenseHeadState {}

class ExpenseHeadLoaded extends ExpenseHeadState {
  final List<ExpenseHeadEntity> expenseHeads;

  ExpenseHeadLoaded({required this.expenseHeads});
}

class ExpenseHeadError extends ExpenseHeadState {
  final String error;

  ExpenseHeadError({required this.error});
}

