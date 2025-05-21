import 'package:equatable/equatable.dart';
import '../../../Domain/Entities/Collection_entities.dart';
import '../../../Domain/Entities/invoice_entities.dart';

abstract class InvoiceEvent extends Equatable {
  const InvoiceEvent();
  @override
  List<Object> get props => [];
}

class SubmitInvoiceEvent extends InvoiceEvent {
  final Invoice invoice;
  const SubmitInvoiceEvent(this.invoice);
  @override
  List<Object> get props => [invoice];
}

class SubmitCollectionEvent extends InvoiceEvent {
  final Collection collection;
  const SubmitCollectionEvent(this.collection);
  @override
  List<Object> get props => [collection];
}

class ClearPrintDataEvent extends InvoiceEvent {}
