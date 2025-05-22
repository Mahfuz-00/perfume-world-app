import 'package:equatable/equatable.dart';

import '../../../Domain/Entities/payment_entities.dart';

abstract class PaymentMethodState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PaymentMethodInitial extends PaymentMethodState {}

class PaymentMethodLoading extends PaymentMethodState {}

class PaymentMethodLoaded extends PaymentMethodState {
  final List<PaymentMethod> paymentMethods;

  PaymentMethodLoaded(this.paymentMethods);

  @override
  List<Object?> get props => [paymentMethods];
}

class PaymentMethodError extends PaymentMethodState {
  final String message;

  PaymentMethodError(this.message);

  @override
  List<Object?> get props => [message];
}