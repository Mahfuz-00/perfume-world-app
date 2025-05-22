import 'package:bloc/bloc.dart';

import 'invoice_print_event.dart';
import 'invoice_print_state.dart';

class InvoicePrintBloc extends Bloc<InvoicePrintEvent, InvoicePrintState> {
  InvoicePrintBloc() : super(InvoicePrintState()) {
    on<InitializePrintData>((event, emit) {
      emit(InvoicePrintState(
        customer: event.customer,
        totalPrice: event.totalPrice,
        invoiceNumber: event.invoiceNumber,
        cartItems: event.cartItems,
        itemDiscounts: event.itemDiscounts,
        vat: event.vat,
        invoiceDiscount: event.invoiceDiscount,
        shipping: event.shipping,
        imagePath: 'Assets/Images/TNS Logo 4X.png',
      ));
    });

    on<UpdatePrintData>((event, emit) {
      emit(state.copyWith(
        paymentMethod: event.paymentMethod,
        collectedAmount: event.collectedAmount,
        checkNo: event.checkNo,
        checkDate: event.checkDate,
        refNo: event.refNo,
        remark: event.remark,
        cashMemoNo: event.cashMemoNo,
      ));
    });

    on<ClearPrintData>((event, emit) {
      emit(InvoicePrintState());
    });
  }
}
