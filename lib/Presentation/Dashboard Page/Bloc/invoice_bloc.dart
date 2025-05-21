import 'package:bloc/bloc.dart';
import 'package:perfume_world_app/Domain/Entities/Collection_entities.dart';
import 'package:perfume_world_app/domain/entities/collection_entities.dart';
import '../../../Domain/Usecases/submit_collection.dart';
import '../../../Domain/Usecases/submit_invoice.dart';
import 'invoice_event.dart';
import 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final SubmitInvoice submitInvoice;
  final SubmitCollection submitCollection;

  InvoiceBloc(this.submitInvoice, this.submitCollection) : super(InvoiceInitial()) {
    on<SubmitInvoiceEvent>(_onSubmitInvoice);
    on<SubmitCollectionEvent>(_onSubmitCollection);
    on<ClearPrintDataEvent>(_onClearPrintData);
  }

  Future<void> _onSubmitInvoice(SubmitInvoiceEvent event, Emitter<InvoiceState> emit) async {
    try {
      final message = await submitInvoice(event.invoice);
      emit(InvoiceSubmitted(message, event.invoice));
    } catch (e) {
      emit(InvoiceError(e.toString()));
    }
  }

  Future<void> _onSubmitCollection(SubmitCollectionEvent event, Emitter<InvoiceState> emit) async {
    try {
      final message = await submitCollection(event.collection);
      emit(CollectionSubmitted(message, event.collection));
    } catch (e) {
      emit(InvoiceError(e.toString()));
    }
  }

  void _onClearPrintData(ClearPrintDataEvent event, Emitter<InvoiceState> emit) {
    emit(InvoiceInitial());
  }
}