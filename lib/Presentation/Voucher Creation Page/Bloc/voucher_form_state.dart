part of 'voucher_form_bloc.dart';

abstract class VoucherFormState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VoucherFormInitial extends VoucherFormState {}

class VoucherFormLoading extends VoucherFormState {}

class VoucherFormSuccess extends VoucherFormState {}

class VoucherFormFailure extends VoucherFormState {
  final String error;

  VoucherFormFailure(this.error);

  @override
  List<Object?> get props => [error];
}
