import 'package:equatable/equatable.dart';

abstract class PaymentMethodEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchPaymentMethods extends PaymentMethodEvent {}

class ClearPaymentMethodEvent extends PaymentMethodEvent {}