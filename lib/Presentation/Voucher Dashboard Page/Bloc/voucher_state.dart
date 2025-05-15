part of 'voucher_bloc.dart';

abstract class VoucherState {}

class VoucherInitial extends VoucherState {}

class VoucherLoading extends VoucherState {}

class VoucherLoaded extends VoucherState {
  final List<VoucherEntity> vouchers;

  VoucherLoaded({required this.vouchers});
}

class VoucherError extends VoucherState {
  final String message;

  VoucherError({required this.message});
}
