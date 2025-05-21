import 'package:equatable/equatable.dart';

import '../../../Domain/Entities/Collection_entities.dart';
import '../../../Domain/Entities/invoice_entities.dart';

abstract class InvoiceState extends Equatable {
  const InvoiceState();
  @override
  List<Object> get props => [];
}

class InvoiceInitial extends InvoiceState {}

class InvoiceSubmitted extends InvoiceState {
  final String message;
  final Invoice invoice;
  const InvoiceSubmitted(this.message, this.invoice);
  @override
  List<Object> get props => [message, invoice];
}

class CollectionSubmitted extends InvoiceState {
  final String message;
  final Collection collection;
  const CollectionSubmitted(this.message, this.collection);
  @override
  List<Object> get props => [message, collection];
}

class InvoiceError extends InvoiceState {
  final String message;
  const InvoiceError(this.message);
  @override
  List<Object> get props => [message];
}
