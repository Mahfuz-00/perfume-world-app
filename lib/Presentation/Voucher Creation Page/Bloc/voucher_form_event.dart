part of 'voucher_form_bloc.dart';

abstract class VoucherFormEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitVoucherFormEvent extends VoucherFormEvent {
  final VoucherFormEntity voucher;

  SubmitVoucherFormEvent(this.voucher);

  @override
  List<Object?> get props => [voucher];
}

